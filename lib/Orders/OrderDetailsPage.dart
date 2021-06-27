import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title:
              Text("Chi tiết đơn hàng", style: TextStyle(color: Colors.white)),
          // actions: [
          //   IconButton(
          //       icon: Icon(
          //         Icons.arrow_drop_down_circle,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {
          //         SystemNavigator.pop();
          //       }),
          // ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dataMap[EcommerceApp.totalAmount].toString() +
                                    "VNĐ/1Kg",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(4.0),
                          //   child: Text("Số đơn hàng: " + getOrderId),
                          // ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ngày đặt hàng: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("posts")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                      check: false,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Thành công" : msg = "Thất bại";

    return Container(
        // decoration: new BoxDecoration(
        //   gradient: new LinearGradient(
        //     colors: [Colors.pink, Colors.lightGreenAccent],
        //     begin: const FractionalOffset(0.0, 0.0),
        //     end: const FractionalOffset(1.0, 0.0),
        //     stops: [0.0, 1.0],
        //     tileMode: TileMode.clamp,
        //   ),
        // ),
        // height: 40.0,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         SystemNavigator.pop();
        //       },
        //     ),
        //     SizedBox(
        //       width: 20.0,
        //     ),
        //     Text(
        //       "Nơi nhận hàng " + msg,
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     SizedBox(
        //       width: 5.0,
        //     ),
        //     CircleAvatar(
        //       radius: 8.0,
        //       backgroundColor: Colors.grey,
        //       child: Center(
        //         child: Icon(
        //           iconData,
        //           color: Colors.white,
        //           size: 14.0,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Địa chỉ nhận nông sản",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(
                    msg: "Tên",
                  ),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Nơi ở",
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Địa chỉ nhận",
                  ),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Mã pin",
                  ),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmUserOrderReceived(context, getOrderId);
              },
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
                    "xác nhận, đơn hàng đã được chuyển.",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmUserOrderReceived(BuildContext context, String mOrderId) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          double ratting = 0;
          return AlertDialog(
            key: key,
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 80,
                  // width: 300,
                  child: Column(
                    children: [
                      Text("Đánh giá nông sản"),
                      SizedBox(
                        height: 20,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 4,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() => {ratting = rating});
                          print(rating);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return LoadingAlertDialog(
                          message: "Đang xử lý ..",
                        );
                      });

                  Map dataMap;

                  DocumentSnapshot snapDoc = await EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.collectionOrders)
                      .document(mOrderId)
                      .get();

                  if (snapDoc.exists) {
                    dataMap = snapDoc.data;
                  }

                  QuerySnapshot snapshot = await EcommerceApp.firestore
                      .collection("posts")
                      .where("shortInfo",
                          whereIn: dataMap[EcommerceApp.productID])
                      .getDocuments();

                  snapshot.documents.forEach((doc) {
                    ItemModel model = ItemModel.fromDocument(doc);

                    Firestore.instance
                        .collection("CommentRate")
                        .document(model.productID)
                        .collection("userId")
                        .document(EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userUID))
                        .setData({
                      "userID": EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID)
                          .trim(),
                      "name": EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userName)
                          .trim(),
                      "url": EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl)
                          .trim(),
                      "ratting": ratting,
                      "timestamp": DateTime.now(),
                      EcommerceApp.userCartList: ["garbageValue"],
                    });

                    // print('Activity Feed Item: ${doc.data}');
                  });

                  EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.collectionOrders)
                      .document(mOrderId)
                      .delete();

                  getOrderId = "";

                  Route route =
                      MaterialPageRoute(builder: (c) => SplashScreen());
                  Navigator.pushReplacement(context, route);

                  Fluttertoast.showToast(msg: "Hoàn thành");
                },
                color: Colors.red,
                child: Center(
                  child: Text("OK"),
                ),
              )
            ],
          );
        });
  }
}

class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
