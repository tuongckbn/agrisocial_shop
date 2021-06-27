import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  String productID;
  String ownerID;
  String finish;
  int price;
  dynamic likes;

  ItemModel(
      {this.title,
      this.finish,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.productID,
      this.ownerID,
      this.likes,
      this.price});

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    productID = json['productID'];
    ownerID = json['ownerID'];
    finish = json['finish'];
  }

  // factory ItemModel.fromDocument(DocumentSnapshot doc) {
  //   return ItemModel(
  //     postId: doc['postId'],
  //     ownerId: doc['ownerId'],
  //     username: doc['username'],
  //     location: doc['location'],
  //     description: doc['description'],
  //     mediaUrl: doc['mediaUrl'],
  //     likes: doc['likes'],
  //   );
  // }
  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      title: doc['title'],
      shortInfo: doc['shortInfo'],
      publishedDate: doc['publishedDate'],
      thumbnailUrl: doc['thumbnailUrl'],
      longDescription: doc['longDescription'],
      status: doc['status'],
      price: doc['price'],
      productID: doc['productID'],
      ownerID: doc['ownerID'],
      likes: doc['likes'],
      finish: doc['finish'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['productID'] = this.productID;
    data['ownerID'] = this.ownerID;
    data['finish'] = this.finish;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
