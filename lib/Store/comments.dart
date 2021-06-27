import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String productID;
  final String ownerID;
  final String userAvatarUrl;
  final String postUrl;

  Comments({this.productID, this.ownerID, this.userAvatarUrl, this.postUrl});

  @override
  CommentsState createState() => CommentsState(
        productID: this.productID,
        ownerID: this.ownerID,
        userAvatarUrl: this.userAvatarUrl,
        postUrl: this.postUrl,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController _commentController = TextEditingController();
  final commentsRef = Firestore.instance;
  final String productID;
  final String ownerID;
  final String userAvatarUrl;
  final String postUrl;

  CommentsState({
    this.productID,
    this.ownerID,
    this.userAvatarUrl,
    this.postUrl,
  });

  buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsRef
          .collection('comments')
          .document(productID)
          .collection('comments')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    commentsRef
        .collection("comments")
        .document(productID)
        .collection("comments")
        .add({
      "username": EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userName)
          .trim(),
      "comment": _commentController.text.trim(),
      "timestamp": Timestamp.now(),
      "avatarUrl": EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userAvatarUrl)
          .trim(),
      "userID":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID).trim(),
    });
    // add comment activity
    bool isNotPostOwner = ownerID ==
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID);
    if (!isNotPostOwner) {
      Firestore.instance
          .collection("feed")
          .document(ownerID)
          .collection("feedItems")
          .add({
        "type": "comment",
        "commentData": _commentController.text,
        "timestamp": DateTime.now(),
        "postId": productID,
        "userId":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "username":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
        "userProfileImg": EcommerceApp.sharedPreferences
            .getString(EcommerceApp.userAvatarUrl),
        "mediaUrl": postUrl,
      });
    }
    _commentController.clear();
    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(labelText: "Nhập bình luận...."),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("post"),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userID;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userID,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userID: doc['userID'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(username),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          subtitle: Text(comment + "\n" + timeago.format(timestamp.toDate())),
          // isThreeLine: Text(timeago.format(timestamp.toDate())),
          isThreeLine: true,
        ),
      ],
    );
  }
}
