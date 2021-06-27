import 'dart:io';
import 'package:flutter/material.dart';

class ModelDetailUpload {
  File file;
  TextEditingController stringProcess = TextEditingController();
  String url = "";

  ModelDetailUpload({this.file = null, stringProcess = ""});
}
