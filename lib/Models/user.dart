import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String name;
  String uid;
  String url;
  String phone;
  // String userCart;

  UserModel({
    this.email,
    this.name,
    this.uid,
    this.url,
    this.phone,
    // this.userCart,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    uid = json['uid'];
    url = json['url'];
    phone = json['phone'];
    // userCart = json['userCart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['url'] = this.url;
    data['phone'] = this.phone;
    // data['userCart'] = this.userCart;
    return data;
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      email: doc['email'],
      name: doc['name'],
      uid: doc['uid'],
      url: doc['url'],
      phone: doc['phone'],
    );
  }
}
