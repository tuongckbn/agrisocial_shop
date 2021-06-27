import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/comment_rate.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'cart.dart';

class CommentRate extends StatefulWidget {
  final String productID;
  final String ownerID;
  final String userAvatarUrl;
  final String postUrl;

  CommentRate({this.productID, this.ownerID, this.userAvatarUrl, this.postUrl});
  @override
  _CommentRateState createState() => _CommentRateState(
        productID: this.productID,
        ownerID: this.ownerID,
        userAvatarUrl: this.userAvatarUrl,
        postUrl: this.postUrl,
      );
}

class _CommentRateState extends State<CommentRate> {
  final String productID;
  final String ownerID;
  final String userAvatarUrl;
  final String postUrl;

  _CommentRateState({
    this.productID,
    this.ownerID,
    this.userAvatarUrl,
    this.postUrl,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            "AgriSocial",
            style: TextStyle(
                fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.5,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userCartList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildComments(widget.productID),
            ),
          ],
        ),
      ),
    );
  }

  buildComments(String productID) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('CommentRate')
          .document(productID)
          .collection('userId')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<CommentRateLess> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(CommentRateLess.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }
}

class CommentRateLess extends StatelessWidget {
  final String name;
  final String url;
  final double ratting;
  final Timestamp timestamp;

  CommentRateLess({
    this.name,
    this.url,
    this.ratting,
    this.timestamp,
  });

  factory CommentRateLess.fromDocument(DocumentSnapshot doc) {
    return CommentRateLess(
      name: doc['name'],
      url: doc['url'],
      ratting: doc['ratting'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(name),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(url),
          ),
          // subtitle: Text(
          //     ratting.toString() + "\n" + timeago.format(timestamp.toDate())),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: ratting,
                minRating: 1,
                // direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 4,
                itemSize: 20,
                wrapAlignment: WrapAlignment.start,
                // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              Text(timeago.format(timestamp.toDate()))
            ],
          ),
          isThreeLine: true,
        ),
      ],
    );
  }
}
