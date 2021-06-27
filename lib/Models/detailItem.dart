import 'package:cloud_firestore/cloud_firestore.dart';

class DetailItem {
  String titleProcess;
  String thumbnailUrl;

  DetailItem({
    this.titleProcess,
    this.thumbnailUrl,
  });

  DetailItem.fromJson(Map<String, dynamic> json) {
    titleProcess = json['titleProcess'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titleProcess'] = this.titleProcess;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}
