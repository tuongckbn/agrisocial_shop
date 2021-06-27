import 'dart:io';

import 'package:e_shop/Store/ModelDetailUpload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnDelete();

class WidgetDetailUpload extends StatefulWidget {
  final ModelDetailUpload detailUpload;
  final OnDelete onDelete;

  WidgetDetailUpload({this.detailUpload, this.onDelete});
  @override
  _WidgetDetailUploadState createState() => _WidgetDetailUploadState();
}

class _WidgetDetailUploadState extends State<WidgetDetailUpload> {
  // File file;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => takeImage(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0), //or 15.0
              child: Container(
                width: 80.0,
                height: 80.0,
                color: Colors.grey,
                child: widget.detailUpload.file == null
                    ? Icon(Icons.add_photo_alternate,
                        color: Colors.white, size: 50.0)
                    : Image.file(
                        widget.detailUpload.file,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ),
          Container(
            width: 100.0,
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: TextField(
              style: TextStyle(color: Colors.deepPurpleAccent),
              controller: widget.detailUpload.stringProcess,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 5.0),
                hintText: "Quá trình",
                hintStyle: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Thêm hình ảnh",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Sử dụng máy ảnh",
                    style: TextStyle(
                      color: Colors.green,
                    )),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Lấy ảnh có sẵn",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Hủy bỏ",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      widget.detailUpload.file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      widget.detailUpload.file = imageFile;
    });
  }
}
