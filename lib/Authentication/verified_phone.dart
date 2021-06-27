import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Models/user.dart';
import 'package:e_shop/Store/profile.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifiedPhone extends StatefulWidget {
  String userId;
  String phone;

  VerifiedPhone({this.userId, this.phone});

  @override
  _VerifiedPhoneState createState() => _VerifiedPhoneState();
}

class _VerifiedPhoneState extends State<VerifiedPhone> {
  final _phoneTextController = TextEditingController();
  final _smsCodeTextController = TextEditingController();
  String _verificationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: backLogin,
        // ),
        centerTitle: true,
        title: Text(
          "AgriSocial",
          style: TextStyle(
              fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/holding-phone.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              (widget.phone == "")
                  ? _phoneSmsTextFormField()
                  : _smsUpTextFormField()
            ],
          ),
        ),
      ),
    );
  }

  // backLogin() {

  // }

  Widget _phoneSmsTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        right: 5.0,
        left: 5.0,
        bottom: 5.0,
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(1),
                ),
              ),
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
                        icon: Icon(Icons.phone),
                        labelText: 'Số điện thoại',
                        hintText: 'Nhập số điện thoại....',
                      ),
                      validator: (String value) =>
                          value.trim().isEmpty ? 'Phone is required' : null,
                      controller: _phoneTextController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 60,
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(1),
                ),
              ),
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
                        icon: Icon(Icons.mark_email_read_outlined),
                        labelText: 'OTP',
                        hintText: 'Nhập OTP',
                      ),
                      validator: (String value) =>
                          value.trim().isEmpty ? 'OTP is required' : null,
                      controller: _smsCodeTextController,
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    // padding: EdgeInsets.all(16),
                    textColor: Colors.black,
                    // color: Colors.yellow,
                    onPressed: () => _requestSMSCodeUsingPhoneNumber(),
                    child: Text("Nhận otp"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(16),
              textColor: Colors.black,
              color: Colors.white,
              onPressed: () => _signInWithPhoneNumberAndSMSCode(),
              child: Text("Tiếp tục"),
            ),
            // SizedBox(
            //   height: 200.0,
            //   child: Image.asset(
            //     'images/holding-phone.png',
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: Column(
    //     children: [
    //       TextFormField(
    //         // keyboardType: ,
    //         decoration: InputDecoration(
    //           border: InputBorder.none,
    //           icon: Icon(Icons.phone),
    //           labelText: 'Số điện thoại',
    //           hintText: 'Nhập số điện thoại....',
    //         ),
    //         validator: (String value) =>
    //             value.trim().isEmpty ? 'Phone is required' : null,
    //         controller: _phoneTextController,
    //       ),
    //       SizedBox(
    //         height: 15.0,
    //       ),
    //       TextFormField(
    //         // keyboardType: ,
    //         decoration: InputDecoration(
    //           border: InputBorder.none,
    //           icon: Icon(Icons.phone),
    //           labelText: 'OTP',
    //           hintText: 'Nhập OTP....',
    //         ),
    //         validator: (String value) =>
    //             value.trim().isEmpty ? 'OTP is required' : null,
    //         controller: _smsCodeTextController,
    //       ),
    //       SizedBox(
    //         height: 15.0,
    //       ),
    //       RaisedButton(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: new BorderRadius.circular(12.0),
    //         ),
    //         padding: EdgeInsets.all(16),
    //         textColor: Colors.black,
    //         color: Colors.white,
    //         onPressed: () => _requestSMSCodeUsingPhoneNumber(),
    //         child: Text("Nhận sms..."),
    //       ),
    //       RaisedButton(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: new BorderRadius.circular(12.0),
    //         ),
    //         padding: EdgeInsets.all(16),
    //         textColor: Colors.black,
    //         color: Colors.white,
    //         onPressed: () => _signInWithPhoneNumberAndSMSCode(),
    //         child: Text("Đăng nhập..."),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _smsUpTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        right: 5.0,
        left: 5.0,
        bottom: 5.0,
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            // color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
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
                      icon: Icon(Icons.mark_email_read_outlined),
                      labelText: 'OTP',
                      hintText: 'Nhập OTP',
                    ),
                    validator: (String value) =>
                        value.trim().isEmpty ? 'OTP is required' : null,
                    controller: _smsCodeTextController,
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  // padding: EdgeInsets.all(16),
                  textColor: Colors.black,
                  // color: Colors.yellow,
                  onPressed: () => _requestSMSCodeUsingPhoneNumber(),
                  child: Text("Nhận OTP"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.all(16),
            textColor: Colors.black,
            color: Colors.white,
            onPressed: () => _signInWithPhoneNumberAndSMSCode(),
            child: Text("Tiếp tục"),
          ),
          // SizedBox(
          //   height: 200.0,
          //   child: Image.asset('images/holding-phone.png'),
          // ),
        ],
      ),
    );
  }

  void _requestSMSCodeUsingPhoneNumber() async {
    if (widget.phone != "") {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phone.trim(),
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) =>
              print('Sign up with phone complete'),
          verificationFailed: (AuthException error) =>
              // print('error message is ${error.message}'),
              {
                showDialog(
                    context: context,
                    builder: (c) {
                      return ErrorAlertDialog(
                        message: "Có lỗi xảy ra: ${error.message}",
                      );
                    })
              },
          codeSent: (String verificationId, [int forceResendingToken]) {
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Mã đã được gửi về điện thoại",
                  );
                });
            print('verificationId is $verificationId');
            setState(() => _verificationId = verificationId);
          },
          codeAutoRetrievalTimeout: null);
    } else {
      if (_phoneTextController.text == "") {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "SĐT đang để trống",
              );
            });
      } else {
        String phoneCheck = "+84" +
            _phoneTextController.text
                .substring(4, _phoneTextController.text.length);
        DocumentReference documentReference =
            Firestore.instance.collection("phones").document(phoneCheck);
        StreamSubscription<DocumentSnapshot> subscription;
        subscription =
            documentReference.snapshots().listen((datasnapshot) async {
          if (datasnapshot.exists) {
            // Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "SĐT đã được đăng ký tại tài khoản khác.",
                  );
                });
          } else if (!datasnapshot.exists) {
            await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+84" + _phoneTextController.text,
                timeout: Duration(seconds: 60),
                verificationCompleted: (AuthCredential phoneAuthCredential) =>
                    showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "Mã đã được gửi về điện thoại",
                          );
                        }),
                verificationFailed: (AuthException error) =>
                    // print('error message is ${error.message}'),
                    {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Có lỗi xảy ra: ${error.message} !",
                            );
                          })
                    },
                codeSent: (String verificationId, [int forceResendingToken]) {
                  // print('verificationId is $verificationId');
                  showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: "Mã đã được gửi về điện thoại",
                        );
                      });
                  setState(() => _verificationId = verificationId);
                },
                codeAutoRetrievalTimeout: null);
          }
        });
      }
    }
  }

  _signInWithPhoneNumberAndSMSCode() async {
    if (_smsCodeTextController != null && _verificationId != null) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "Đang xử lý ..",
            );
          });
      AuthCredential authCreds = PhoneAuthProvider.getCredential(
          verificationId: _verificationId,
          smsCode: _smsCodeTextController.text);
      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(authCreds)).user;
      // print("User Phone number is" + user.phoneNumber);

      _smsCodeTextController.text = '';
      _phoneTextController.text = '';
      setState(() => _verificationId = null);
      FocusScope.of(context).requestFocus(FocusNode());
      // _showSnackBar('Sign up with phone success. Check your firebase.');
      final DocumentSnapshot doc =
          await Firestore.instance.collection("users").document(user.uid).get();

      if (!doc.exists) {
        // 2) if the user doesn't exist, then we want to take them to the create account page
        // final username = await Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => CreateAccount()));
        await Firestore.instance
            .collection('phones')
            .document(user.phoneNumber)
            .setData({
          "phone": user.phoneNumber,
        });
        await Firestore.instance
            .collection('users')
            .document(widget.userId)
            .updateData({
          "phone": user.phoneNumber.trim(),
        });
        DocumentSnapshot snapshot = await Firestore.instance
            .collection('users')
            .document(widget.userId)
            .get();
        UserModel userTranfer = UserModel.fromDocument(snapshot);
        // 3) get username from create account, use it to make new user document in users collection
        Firestore.instance.collection("users").document(user.uid).setData({
          "uid": user.uid,
          "name": userTranfer.name,
          "url": userTranfer.url,
          "email": userTranfer.email,
          "phone": user.phoneNumber,
          EcommerceApp.userCartList: ["garbageValue"],
        });
      }
      if (user != null) {
        return readData(user).then((s) {
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Hãy nhập các trường còn trống",
            );
          });
    }

    // return signUpWithFacebook();
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
