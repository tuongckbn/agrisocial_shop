// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/ModelDetailUpload.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Store/widgetDetailUpload.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

import '../Widgets/loadingWidget.dart';
import '../main.dart';
// import 'adminShiftOrders.dart';

class UploadItemsUser extends StatefulWidget {
  @override
  _UploadItemsUserState createState() => _UploadItemsUserState();
}

class _UploadItemsUserState extends State<UploadItemsUser>
    with AutomaticKeepAliveClientMixin<UploadItemsUser> {
  bool get wantKeepAlive => true;
//tuongcntt24
  List<ModelDetailUpload> detailUploads = [];

  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  TextEditingController _processTextEditingController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      detailUploads.add(ModelDetailUpload());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: displayAdminUploadFormScreen());
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "Nông sản mới",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   FlatButton(
        //       onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
        //       child: Text(
        //         "Add",
        //         style: TextStyle(
        //           color: Colors.pink,
        //           fontSize: 16.0,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       )),
        // ],
      ),
      body: displayAdminUploadFormScreen(),
    );
  }

  // takeImage(mContext) {
  //   return showDialog(
  //       context: mContext,
  //       builder: (con) {
  //         return SimpleDialog(
  //           title: Text(
  //             "Thêm hình ảnh",
  //             style:
  //                 TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
  //           ),
  //           children: [
  //             SimpleDialogOption(
  //               child: Text("Sử dụng máy ảnh",
  //                   style: TextStyle(
  //                     color: Colors.green,
  //                   )),
  //               onPressed: capturePhotoWithCamera,
  //             ),
  //             SimpleDialogOption(
  //               child: Text(
  //                 "Lấy ảnh có sẵn",
  //                 style: TextStyle(
  //                   color: Colors.green,
  //                 ),
  //               ),
  //               onPressed: pickPhotoFromGallery,
  //             ),
  //             SimpleDialogOption(
  //               child: Text(
  //                 "Hủy bỏ",
  //                 style: TextStyle(color: Colors.green),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  // capturePhotoWithCamera() async {
  //   Navigator.pop(context);
  //   File imageFile = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

  //   setState(() {
  //     file = imageFile;
  //   });
  // }

  // pickPhotoFromGallery() async {
  //   Navigator.pop(context);
  //   File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     file = imageFile;
  //   });
  // }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "Nông sản mới",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   FlatButton(
        //       onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
        //       child: Text(
        //         "Add",
        //         style: TextStyle(
        //           color: Colors.pink,
        //           fontSize: 16.0,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       )),
        // ],
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: [
            uploading ? circularProgress() : Text(""),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: onAdd,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: detailUploads.length,
                    itemBuilder: (_, i) => WidgetDetailUpload(
                      detailUpload: detailUploads[i],
                      onDelete: () => onDelete(i),
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.perm_device_information,
            //     color: Colors.pink,
            //   ),
            //   title: Container(
            //     width: 250.0,
            //     child:
            //     // ,TextField(
            //     //   style: TextStyle(color: Colors.deepPurpleAccent),
            //     //   controller: _shortInfoTextEditingController,
            //     //   decoration: InputDecoration(
            //     //     hintText: "Short Info",
            //     //     hintStyle: TextStyle(color: Colors.deepPurpleAccent),
            //     //     border: InputBorder.none,
            //     //   ),
            //     // ),
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  // keyboardType: ,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Tên nông sản',
                  ),
                  validator: (String value) =>
                      value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                  controller: _titleTextEditingController,
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            Container(
              width: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  // keyboardType: ,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Mô tả ngắn về nông sản',
                  ),
                  validator: (String value) =>
                      value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                  controller: _shortInfoTextEditingController,
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            Container(
              width: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  // keyboardType: ,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Mô tả về nông sản',
                  ),
                  validator: (String value) =>
                      value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                  controller: _descriptionTextEditingController,
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            Container(
              width: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Giá bán',
                  ),
                  validator: (String value) =>
                      value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                  controller: _priceTextEditingController,
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            Container(
              height: 60,
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
                          // icon: Icon(Icons.gps_off_sharp),
                          labelText: 'Vị trí nuôi cấy',
                        ),
                        validator: (String value) =>
                            value.trim().isEmpty ? 'Bắt buộc nhập' : null,
                        controller: _locationController,
                      ),
                    ),
                    RaisedButton.icon(
                      label: Text(
                        "GPS",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blue,
                      onPressed: getUserLocation,
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Divider(
              color: Colors.pink,
            ),
            RaisedButton(
              onPressed: () => {
                if (_key.currentState.validate()) {uploadImageAndSaveItemInfo()}
              },
              color: Colors.pink,
              child: Text(
                "Đăng tải",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: onAdd,
      // ),
    );
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

  void onDelete(int index) {
    setState(() {
      detailUploads.removeAt(index);
    });
  }

  void onAdd() {
    setState(() {
      detailUploads.add(ModelDetailUpload());
    });
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _processTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    for (int i = 0; i < detailUploads.length; i++) {
      if (detailUploads[i].file == null ||
          detailUploads[i].stringProcess.text == "" ||
          detailUploads[i].stringProcess.text == null) {
        setState(() {
          uploading = false;
        });
        return showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Vui lòng nhập đủ trường còn thiếu",
              );
            });
      }
    }

    if (uploading) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "Đăng tải nông sản ..",
            );
          });
    }
    // master
    // detail
    List<String> imageDetail = [];
    // detailUploads.toList().asMap().forEach((index, element) async {
    //   String s = await uploadItemImage(element.file);
    //   detailUploads[index].url = s;
    // });
    detailUploads;
    for (int i = 0; i < detailUploads.length; i++) {
      detailUploads[i].url = await uploadItemImage(detailUploads[i].file);
    }
    saveItemDetail(detailUploads);

    String imageDownloadUrl = await uploadItemImage(detailUploads[0].file);

    saveItemInfo(imageDownloadUrl);
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  saveItemDetail(List<ModelDetailUpload> upload) {
    upload.forEach((element) {
      final itemsRef = Firestore.instance
          .collection("itemDetail")
          .document(productId)
          .collection("details")
          .add({
        "titleProcess": element.stringProcess.text.trim(),
        "thumbnailUrl": element.url.trim(),
        "timestamp": Timestamp.now(),
      });
    });
    setState(() {
      // uploading = null;
      // upload.clear();
    });
  }

  Future<String> uploadItemImage(mFileImage) async {
    String iamgeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference
        .child("product_$iamgeFileName.jpg")
        .putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef =
        Firestore.instance.collection("posts").document(productId).setData({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text.trim()),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
      "productID": productId.trim(),
      "location": _locationController.text.trim(),
      "finish": "false",
      "ownerID":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID).trim(),
      "likes": {},
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
      detailUploads.clear();
      _locationController.clear();
    });
  }
}
