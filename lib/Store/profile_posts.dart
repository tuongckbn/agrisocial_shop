import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePosts extends StatefulWidget {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  String productID;
  String ownerID;
  int price;

  ProfilePosts({
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.productID,
    this.ownerID,
    this.price,
  });

  factory ProfilePosts.fromDocument(DocumentSnapshot doc) {
    return ProfilePosts(
      title: doc['title'],
      shortInfo: doc['shortInfo'],
      publishedDate: doc['publishedDate'],
      thumbnailUrl: doc['thumbnailUrl'],
      longDescription: doc['longDescription'],
      status: doc['status'],
      price: doc['price'],
      productID: doc['productID'],
      ownerID: doc['ownerID'],
    );
  }

  @override
  _ProfilePostsState createState() => _ProfilePostsState(
        title: this.title,
        shortInfo: this.shortInfo,
        publishedDate: this.publishedDate,
        thumbnailUrl: this.thumbnailUrl,
        longDescription: this.longDescription,
        status: this.status,
        price: this.price,
        productID: this.productID,
        ownerID: this.ownerID,
      );
}

class _ProfilePostsState extends State<ProfilePosts> {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  String productID;
  String ownerID;
  int price;

  _ProfilePostsState({
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.productID,
    this.ownerID,
    this.price,
  });
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
