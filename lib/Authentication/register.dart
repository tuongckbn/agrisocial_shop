import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Authentication/verified_phone.dart';
import 'package:e_shop/Models/user.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import '../Config/config.dart';
import '../Config/config.dart';
import '../DialogBox/errorDialog.dart';
// import '../DialogBox/errorDialog.dart';
// import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

import '../Widgets/customTextField.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  //Animation Declaration
  AnimationController sanimationController;
  AnimationController animationControllerScreen;
  Animation animationScreen;
  var tap = 0;

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  void initState() {
    sanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tap = 0;
              });
            }
          });
    // TODO: implement initState
    super.initState();
  }

  /// Dispose animationController
  @override
  void dispose() {
    super.dispose();
    sanimationController.dispose();
  }

  /// Playanimation set forward reverse
  Future<Null> _PlayAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.height;
    mediaQueryData.size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            /// Set Background image in layout
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/pexels-zen-chung-5529001.jpg"),
              fit: BoxFit.cover,
            )),
            child: Container(
              /// Set gradient color in image
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.2),
                    Color.fromRGBO(0, 0, 0, 0.3)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),

              /// Set component layout
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: AlignmentDirectional.topCenter,
                            child: Column(
                              children: <Widget>[
                                /// padding logo
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            mediaQueryData.padding.top + 40.0)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // Image(
                                    //   image: AssetImage("images/Logo.png"),
                                    //   height: 100.0,
                                    //   width: 70,
                                    //   fit: BoxFit.fitHeight,
                                    // ),
                                    // Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 10.0)),

                                    /// Animation text treva shop accept from login layout
                                    Hero(
                                      tag: "AgriSocial",
                                      child: Text(
                                        "AgriSocial Shop",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                            fontFamily: "Sans",
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0)),
                                InkWell(
                                  onTap: () => _selectAndPickImage(),
                                  child: CircleAvatar(
                                    radius: mediaQueryData.size.width * 0.15,
                                    backgroundColor: Colors.white,
                                    backgroundImage: _imageFile == null
                                        ? null
                                        : FileImage(_imageFile),
                                    child: _imageFile == null
                                        ? Icon(
                                            Icons.add_photo_alternate,
                                            size: mediaQueryData.size.width *
                                                0.15,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0)),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      /// TextFromField Name
                                      textFromField(
                                        icon: Icons.person,
                                        password: false,
                                        email: "Họ, Tên",
                                        inputType: TextInputType.text,
                                        textController:
                                            _nameTextEditingController,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0)),

                                      /// TextFromField Email
                                      textFromField(
                                        icon: Icons.email,
                                        password: false,
                                        email: "Email",
                                        inputType: TextInputType.emailAddress,
                                        textController:
                                            _emailTextEditingController,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0)),

                                      /// TextFromField Password
                                      textFromField(
                                        icon: Icons.vpn_key,
                                        password: true,
                                        email: "Mật khẩu",
                                        inputType: TextInputType.text,
                                        textController:
                                            _passwordTextEditingController,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0)),

                                      /// TextFromField confirm password
                                      textFromField(
                                        icon: Icons.vpn_key,
                                        password: true,
                                        email: "Nhập lại mật khẩu",
                                        inputType: TextInputType.text,
                                        textController:
                                            _cpasswordTextEditingController,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0)),

                                      /// Button Login
                                      FlatButton(
                                          padding: EdgeInsets.only(top: 20.0),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new Login()));
                                          },
                                          child: Text(
                                            " Đăng nhập bằng tài khoản",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Sans"),
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQueryData.padding.top +
                                                0.0,
                                            bottom: 0.0),
                                      ),

                                      /// Set Animaion after user click buttonLogin
                                      tap == 0
                                          ? InkWell(
                                              splashColor: Colors.yellow,
                                              onTap: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    tap = 1;
                                                  });

                                                  uploadAndSaveImage();

                                                  return tap;
                                                }
                                              },
                                              child: buttonBlackBottom(),
                                            )
                                          : new LoginAnimation(
                                              animationController:
                                                  sanimationController.view,
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Hình đại diện để trống !",
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cpasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Không để trống bất cứ trường nào.")
          : displayDialog("Mật khẩu không khớp nhau.");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "'Hệ thống đang xác thực..'",
          );
        });

    String iamgeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(iamgeFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      // Navigator.pop(context);
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      setState(() {
        tap = 0;
      });
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) async {
        // Navigator.pop(context);
        DocumentSnapshot snapshot = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        UserModel userTranfer = UserModel.fromDocument(snapshot);

        EcommerceApp.auth.signOut().then((c) {
          _PlayAnimation();
          Route route = MaterialPageRoute(
            builder: (c) => VerifiedPhone(
              userId: userTranfer.uid,
              phone: "",
            ),
          );
          Navigator.pushReplacement(context, route);
        });
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      "phone": "",
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

/// textfromfield custom class
class textFromField extends StatelessWidget {
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;
  TextEditingController textController;

  textFromField({
    this.email,
    this.icon,
    this.inputType,
    this.password,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            obscureText: password,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
            validator: (String value) =>
                value.trim().isEmpty ? 'Bắt buộc nhập' : null,
            controller: textController,
          ),
        ),
      ),
    );
  }
}

///ButtonBlack class
class buttonBlackBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Container(
        height: 55.0,
        width: 600.0,
        child: Text(
          "Đăng ký",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: "Sans",
              fontSize: 18.0,
              fontWeight: FontWeight.w800),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
      ),
    );
  }
}
