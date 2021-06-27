// import 'dart:html';

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/Models/detailItem.dart';
import 'package:e_shop/Store/commentRate.dart';
import 'package:e_shop/Store/comments.dart';
import 'package:e_shop/Store/update_post.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constant_popup_menu.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isFollowing = false;
  int quantityOfItems = 1;
  int _current = 0;
  List<DetailItem> lists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLike();
  }

  getLike() async {
    StreamSubscription<DocumentSnapshot> subscription;
    final DocumentReference documentReference = Firestore.instance
        .collection("userFollows")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("followPosts")
        .document(widget.itemModel.productID);
    subscription = documentReference.snapshots().listen((datasnapshot) {
      //FINDING A SPECIFICDOCUMENT IS EXISTING INSIDE A COLLECTION

      if (datasnapshot.exists) {
        setState(() {
          isFollowing = true;
        });
      } else if (!datasnapshot.exists) {
        setState(() {
          isFollowing = false;
        });
      }
    });
  }

  getImgFireBase() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("itemDetail")
        .document(widget.itemModel.productID)
        .collection("details")
        .orderBy("timestamp", descending: false)
        .getDocuments();
    qn.documents;
    List<DetailItem> ls = [];
    for (int i = 0; i < qn.documents.length; i++) {
      DetailItem model = DetailItem.fromJson(qn.documents[i].data);
      ls.add(model);
    }
    setState(() {
      lists = ls;
    });
  }

  buildFollowButton() {
    bool isProductOwner = widget.itemModel.ownerID ==
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID);
    if (isProductOwner) {
      return GestureDetector(
        onTap: () => Fluttertoast.showToast(msg: "Thao tác thất bại."),
        child: Icon(
          true ? Icons.favorite : Icons.favorite_border,
          size: 28,
          color: Colors.pink,
        ),
      );
    } else {
      if (isFollowing) {
        return GestureDetector(
          onTap: handleUnfollowProduct,
          child: Icon(
            Icons.favorite,
            size: 28,
            color: Colors.pink,
          ),
        );
      } else {
        return GestureDetector(
          onTap: handleFollowProduct,
          child: Icon(
            Icons.favorite_border,
            size: 28,
            color: Colors.pink,
          ),
        );
      }
    }
  }

  handleUnfollowProduct() {
    setState(() {
      isFollowing = false;
    });
    // remove Post duoc user follow
    Firestore.instance
        .collection("followPosts")
        .document(widget.itemModel.productID)
        .collection("userFollows")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove user follow nhieu post
    Firestore.instance
        .collection("userFollows")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("followPosts")
        .document(widget.itemModel.productID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove post in userFollowPosts
    Firestore.instance
        .collection("userFollowPosts")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("posts")
        .document(widget.itemModel.productID)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });
    removeLikeFromActivityFeed();
    Fluttertoast.showToast(msg: "Đã bỏ theo dõi nông sản.");
  }

  handleFollowProduct() async {
    setState(() {
      isFollowing = true;
    });
    // set Post duoc user follow
    Firestore.instance
        .collection("followPosts")
        .document(widget.itemModel.productID)
        .collection("userFollows")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .setData({});
    // set user follow nhieu post
    Firestore.instance
        .collection("userFollows")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("followPosts")
        .document(widget.itemModel.productID)
        .setData({});
    // set userFollowPosts
    Firestore.instance
        .collection("posts")
        .document(widget.itemModel.productID)
        .get()
        .then((doc) => {
              Firestore.instance
                  .collection("userFollowPosts")
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection("posts")
                  .document(widget.itemModel.productID)
                  .setData(doc.data)
            });
    addLikeToActivityFeed();
    Fluttertoast.showToast(msg: "Theo dõi nông sản thành công.");
  }

  addLikeToActivityFeed() {
    Firestore.instance
        .collection("feed")
        .document(widget.itemModel.ownerID)
        .collection("feedItems")
        .document(widget.itemModel.productID)
        .setData({
      "type": "follow",
      "username":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "userId": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "userProfileImg":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
      "postId": widget.itemModel.productID,
      "mediaUrl": widget.itemModel.thumbnailUrl,
      "timestamp": DateTime.now(),
    });
  }

  removeLikeFromActivityFeed() {
    Firestore.instance
        .collection("feed")
        .document(widget.itemModel.ownerID)
        .collection("feedItems")
        .document(widget.itemModel.productID)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  Widget appBarUpdatePost() {
    bool isProductOwner = widget.itemModel.ownerID ==
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID);
    if (isProductOwner) {
      return AppBar(
        backgroundColor: Colors.green,
        brightness: Brightness.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Route route = MaterialPageRoute(
        //           builder: (c) => UpdatePost(
        //                 postID: widget.itemModel.productID,
        //                 postName: widget.itemModel.title,
        //               ));
        //       Navigator.push(context, route);
        //     },
        //     child: Icon(
        //       Icons.favorite_border,
        //       color: Colors.black,
        //     ),
        //   ),
        // ],
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      );
    } else {
      return MyAppBar();
    }
  }

  Future<void> choiceAction(String choice) async {
    // if (choice == Constants.Settings) {
    //   print('Settings');
    // } else if (choice == Constants.Subscribe) {
    //   print('Subscribe');
    // } else if (choice == Constants.SignOut) {
    //   print('SignOut');
    // }
    if (choice == Constants.Subscribe) {
      Route route = MaterialPageRoute(
          builder: (c) => UpdatePost(
                postID: widget.itemModel.productID,
                postName: widget.itemModel.title,
              ));
      Navigator.push(context, route);
    } else if (choice == Constants.Settings) {
      await Firestore.instance
          .collection("posts")
          .document(widget.itemModel.productID)
          .updateData({
        "finish": "true",
      });
      Fluttertoast.showToast(msg: "Mở bán thành công");
    } else if (choice == Constants.SignOut) {
      await Firestore.instance
          .collection("posts")
          .document(widget.itemModel.productID)
          .updateData({
        "finish": "false",
      });
      Fluttertoast.showToast(msg: "Tạm dừng bán");
    }
  }

  @override
  Widget build(BuildContext context) {
    getImgFireBase();
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: appBarUpdatePost(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(0.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextTitleVariation1(widget.itemModel.title),
                            Text(
                              widget.itemModel.price.toString() + "đ/1Kg",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Stack(
                    children: [
                      Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: lists.length,
                            itemBuilder: (ctx, i) {
                              return Column(children: [
                                Container(
                                  height: 200,
                                  child: Image.network(
                                    lists[i].thumbnailUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // width: 100.0,
                                      height: 30.0,
                                      // margin: EdgeInsets.symmetric(
                                      //     vertical: 10.0, horizontal: 2.0),
                                      child: Text(
                                        lists[i].titleProcess.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]);
                            },
                            options: CarouselOptions(
                                height: 230,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: lists.map((a) {
                              {
                                int index = lists.indexOf(a);
                                return Container(
                                  width: 10.0,
                                  height: 10.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Colors.redAccent
                                        : Colors.grey[400],
                                  ),
                                );
                              }
                            }).toList(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 272),
                            child: GestureDetector(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => CommentRate(
                                          productID: widget.itemModel.productID,
                                          ownerID: widget.itemModel.ownerID,
                                          userAvatarUrl: EcommerceApp
                                              .sharedPreferences
                                              .getString(
                                                  EcommerceApp.userAvatarUrl),
                                          postUrl:
                                              widget.itemModel.thumbnailUrl,
                                        ));
                                Navigator.push(context, route);
                              },
                              child: Icon(
                                Icons.rate_review,
                                size: 28.0,
                                color: Colors.yellow[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Positioned(
                        left: 12.0,
                        top: 210.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Padding(padding: EdgeInsets.only(top: 40, left: 20)),
                            buildFollowButton(),
                            // Padding(padding: EdgeInsets.only(right: 20.0)),
                            GestureDetector(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => Comments(
                                          productID: widget.itemModel.productID,
                                          ownerID: widget.itemModel.ownerID,
                                          userAvatarUrl: EcommerceApp
                                              .sharedPreferences
                                              .getString(
                                                  EcommerceApp.userAvatarUrl),
                                          postUrl:
                                              widget.itemModel.thumbnailUrl,
                                        ));
                                Navigator.push(context, route);
                              },
                              child: Icon(
                                Icons.chat,
                                size: 28.0,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mô tả",
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        buildTextSubTitleVariation1(
                          widget.itemModel.longDescription,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Text(
                        //   "" + widget.itemModel.price.toString(),
                        //   style: boldTextStyle,
                        // ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: buildThemVaoGioHang(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () {},
        //     backgroundColor: Colors.green[200],
        //     icon: Icon(
        //       Icons.play_circle_fill,
        //       color: Colors.white,
        //       size: 32,
        //     ),
        //     label: Text(
        //       "Watch Video",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     )),
      ),
    );
  }

  Widget buildThemVaoGioHang() {
    if (widget.itemModel.ownerID ==
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)) {
      return InkWell(
        onTap: () => showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Không thể mua nông sản của mình !",
              );
            }),
        child: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          width: MediaQuery.of(context).size.width - 40.0,
          height: 50.0,
          child: Center(
            child: Text(
              "Thêm vào giỏ hàng",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      if (widget.itemModel.finish == "true") {
        return InkWell(
          onTap: () => checkItemInCart(widget.itemModel.shortInfo, context),
          child: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            child: Center(
              child: Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (c) {
                return ErrorAlertDialog(
                  message: "Chủ sở hữu chưa mở bán nông sản!",
                );
              }),
          child: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            child: Center(
              child: Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
    }
  }

  buildTextTitleVariation1(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  buildTextSubTitleVariation1(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
