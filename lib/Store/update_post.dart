// import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePost extends StatefulWidget {
  final String postID;
  final String postName;
  UpdatePost({this.postID, this.postName});
  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  TextEditingController _processTextEditingController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  File _imageFile;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(),
      // body: Column(
      //   children: [
      //     SingleChildScrollView(
      // child: Container(
      body: Form(
        key: _key,
        child: ListView(
          // mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: InkWell(
                onTap: () => takeImage(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), //or 15.0
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    color: Colors.grey,
                    child: _imageFile == null
                        ? Icon(Icons.add_photo_alternate,
                            color: Colors.white, size: 50.0)
                        : Image.file(
                            _imageFile,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),

                // CircleAvatar(
                //   radius: _screenWidth * 0.15,
                //   backgroundColor: Colors.white,
                //   backgroundImage:
                //       _imageFile == null ? null : FileImage(_imageFile),
                //   child: _imageFile == null
                //       ? Icon(
                //           Icons.add_photo_alternate,
                //           size: _screenWidth * 0.15,
                //           color: Colors.grey,
                //         )
                //       : null,
                // ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 60,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.height * 0.35,
                        color: Colors.white,
                        child: TextFormField(
                          // keyboardType: ,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // icon: Icon(Icons.phone),
                            labelText: 'Tên quá trình',
                          ),
                          validator: (String value) =>
                              value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                          controller: _processTextEditingController,
                        ),
                      ),
                    ]),
              ),
            ),
            // Divider(
            //   color: Colors.pink,
            // ),
            Container(
              // height: 60,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.height * 0.35,
                        color: Colors.white,
                        child: TextFormField(
                          // keyboardType: ,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // icon: Icon(Icons.phone),
                            labelText: 'Vị trí nuôi cấy',
                          ),
                          validator: (String value) =>
                              value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                          controller: _locationController,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        // tooltip: 'Increase volume by 10',
                        onPressed: getUserLocation,
                      ),
                      // RaisedButton.icon(
                      //   label: Text(
                      //     "GPS",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30.0),
                      //   ),
                      //   color: Colors.blue,
                      //   onPressed: getUserLocation,
                      //   icon: Icon(
                      //     Icons.my_location,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ]),
              ),
            ),
            Center(
              child: Container(
                width: 100,
                child: RaisedButton(
                  onPressed: () => {
                    if (_key.currentState.validate()) {uploadAndSaveImage()}
                  },
                  color: Colors.pink,
                  child: Text(
                    "Cập nhật",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
      //     )
      //   ],
      // ),
    );
    // return Text("123");
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    // print(completeAddress);
    String formattedAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
    _locationController.text = formattedAddress;
  }

  Future<void> _selectAndPickImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = imageFile;
    });
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
      _imageFile = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = imageFile;
    });
  }

  uploadAndSaveImage() async {
    if (!uploading) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "Đăng quá trình ..",
            );
          });
    }

    DocumentReference documentReference =
        Firestore.instance.collection("posts").document(widget.postID);
    StreamSubscription<DocumentSnapshot> subscription;
    subscription = documentReference.snapshots().listen((datasnapshot) async {
      if (!datasnapshot.data.containsValue(_locationController.text)) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Vị trí hiện tại không đúng",
              );
            });
      } else if (datasnapshot.data.containsValue(_locationController.text)) {
        if (_imageFile == null) {
          Navigator.pop(context);
          return showDialog(
              context: context,
              builder: (c) {
                return ErrorAlertDialog(
                  message: "Không để ảnh trống",
                );
              });
        }
        String imageDownloadUrl = await uploadItemImage(_imageFile);

        saveItemInfo(imageDownloadUrl);

        DocumentSnapshot doc = await Firestore.instance
            .collection("posts")
            .document(widget.postID)
            .snapshots()
            .first;
        var model = ItemModel.fromJson(doc.data);
        Route route =
            MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
        Navigator.pushReplacement(context, route);

        setState(() {
          uploading = true;
        });
      }
    });
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("itemDetail");
    itemsRef.document(widget.postID).collection("details").document().setData({
      "titleProcess": _processTextEditingController.text.trim(),
      "timestamp": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });
    addUpdateProcessToActivityFeed(downloadUrl);
    setState(() {
      _imageFile = null;
      uploading = null;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _processTextEditingController.clear();
      _locationController.clear();
    });
  }

  addUpdateProcessToActivityFeed(String downloadUrl) async {
    QuerySnapshot qn = await Firestore.instance
        .collection('followPosts')
        .document(widget.postID)
        .collection("userFollows")
        .getDocuments();
    for (int i = 0; i < qn.documents.length; i++) {
      Firestore.instance
          .collection("feed")
          .document(qn.documents[i].documentID.toString())
          .collection("feedItems")
          .add({
        "type": "updateProcess",
        "username":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
        "userId":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "userProfileImg": EcommerceApp.sharedPreferences
            .getString(EcommerceApp.userAvatarUrl),
        "postId": widget.postID,
        "mediaUrl": downloadUrl,
        "timestamp": DateTime.now(),
      });
    }
  }
}
