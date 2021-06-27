import 'package:cloud_firestore/cloud_firestore.dart';

class RateModel {
  String name;
  double ratting;
  Timestamp timestamp;
  String url;

  RateModel({
    this.name,
    this.ratting,
    this.timestamp,
    this.url,
  });

  RateModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ratting = json['ratting'];
    timestamp = json['timestamp'];
    url = json['url'];
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
  factory RateModel.fromDocument(DocumentSnapshot doc) {
    return RateModel(
      name: doc['name'],
      ratting: doc['ratting'],
      timestamp: doc['timestamp'],
      url: doc['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ratting'] = this.ratting;
    data['timestamp'] = this.timestamp;
    data['url'] = this.url;
    return data;
  }
}
