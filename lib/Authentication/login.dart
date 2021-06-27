import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/Authentication/verified_phone.dart';
import 'package:e_shop/Models/user.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Config/config.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

import 'create_account.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController sanimationController;

  var tap = 0;

  PageController pageController;
  bool isAuth = false;

  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  void dispose() {
    super.dispose();
    sanimationController.dispose();
  }

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
    mediaQueryData.size.width;
    mediaQueryData.size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/pexels-markus-spiske-2818573.jpg"),
          fit: BoxFit.cover,
        )),
        child: Container(
          /// Set gradient color in image (Click to open code)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.0),
                Color.fromRGBO(0, 0, 0, 0.3)
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),

          /// Set component layout
          child: ListView(
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
                                    top: mediaQueryData.padding.top + 40.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Image(
                                //   image: AssetImage("images/Logo.png"),
                                //   height: 70.0,
                                // ),
                                // Padding(
                                //     padding:
                                //         EdgeInsets.symmetric(horizontal: 10.0)),

                                /// Animation text treva shop accept from signup layout (Click to open code)
                                Hero(
                                  tag: "AgriSocial",
                                  child: Text(
                                    "AgriSocial Shop",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                        color: Colors.white,
                                        fontFamily: "Sans",
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),

                            /// ButtonCustomFacebook
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.0)),
                            buttonCustomFacebook(),

                            /// ButtonCustomGoogle
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 7.0)),
                            buttonCustomGoogle(),

                            /// Set Text
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            Text(
                              "Hoặc",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                  fontFamily: 'Sans',
                                  fontSize: 17.0),
                            ),

                            /// TextFromField Email
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            textFromField(
                              icon: Icons.email,
                              password: false,
                              email: "Email",
                              inputType: TextInputType.emailAddress,
                              textController: _emailTextEditingController,
                            ),

                            /// TextFromField Password
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0)),
                            textFromField(
                              icon: Icons.vpn_key,
                              password: true,
                              email: "Password",
                              inputType: TextInputType.text,
                              textController: _passwordTextEditingController,
                            ),

                            /// Button Signup
                            FlatButton(
                                padding: EdgeInsets.only(top: 20.0),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Register()));
                                },
                                child: Text(
                                  "Đăng ký tài khoản mới",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Sans"),
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.padding.top + 100.0,
                                  bottom: 0.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Set Animaion after user click buttonLogin
                  tap == 0
                      ? InkWell(
                          splashColor: Colors.yellow,
                          onTap: () {
                            _emailTextEditingController.text.isNotEmpty &&
                                    _passwordTextEditingController
                                        .text.isNotEmpty
                                ? loginRoute()
                                : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorAlertDialog(
                                        message:
                                            "Không để trống bất cứ trường nào.",
                                      );
                                    });
                          },
                          child: buttonBlackBottom(),
                        )
                      : new LoginAnimation(
                          animationController: sanimationController.view,
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginRoute() {
    setState(() {
      tap = 1;
    });
    loginUser();
    // new LoginAnimation(
    //   animationController: sanimationController.view,
    // );
    // _PlayAnimation();
    return tap;
  }

  Widget buttonCustomFacebook() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: InkWell(
        onTap: signUpWithFacebook,
        child: Container(
          alignment: FractionalOffset.center,
          height: 49.0,
          width: 500.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(107, 112, 248, 1.0),
            borderRadius: BorderRadius.circular(40.0),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/icon_facebook.png",
                height: 25.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
              Text(
                "Đăng nhập bằng Facebook",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sans'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonCustomGoogle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: InkWell(
        onTap: createUserInFirestore,
        child: Container(
          alignment: FractionalOffset.center,
          height: 49.0,
          width: 500.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/google.png",
                height: 25.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
              Text(
                "Đăng nhập Google",
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sans'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      final DocumentSnapshot doc =
          await Firestore.instance.collection("users").document(user.uid).get();

      if (!doc.exists) {
        // 2) if the user doesn't exist, then we want to take them to the create account page
        // final username = await Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => CreateAccount()));

        // 3) get username from create account, use it to make new user document in users collection
        Firestore.instance.collection("users").document(user.uid).setData({
          "uid": user.uid,
          "name": user.displayName,
          "url": user.photoUrl,
          "email": user.email,
          "phone": "",
          EcommerceApp.userCartList: ["garbageValue"],
        });
      }
      DocumentSnapshot snapshot =
          await Firestore.instance.collection('users').document(user.uid).get();
      UserModel userTranfer = UserModel.fromDocument(snapshot);

      EcommerceApp.auth.signOut().then((c) {
        Route route = MaterialPageRoute(
          builder: (c) => VerifiedPhone(
            userId: userTranfer.uid,
            phone: userTranfer.phone,
          ),
        );
        Navigator.pushReplacement(context, route);
      });
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> createUserInFirestore() async {
    // final GoogleSignIn _googleSignIn = GoogleSignIn(
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Đang xử lý ..",
          );
        });

    // final FirebaseUser user =
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    // final DocumentSnapshot doc =
    DocumentSnapshot doc =
        await Firestore.instance.collection("users").document(user.uid).get();

    if (!doc.exists) {
      Firestore.instance.collection("users").document(user.uid).setData({
        "uid": user.uid,
        "name": user.displayName,
        "url": user.photoUrl,
        "email": user.email,
        "phone": "",
        EcommerceApp.userCartList: ["garbageValue"],
      });
    }
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();
    UserModel userTranfer = UserModel.fromDocument(snapshot);
    Navigator.pop(context);
    await EcommerceApp.auth.signOut().then((c) {
      Route route = MaterialPageRoute(
        builder: (c) => VerifiedPhone(
          userId: userTranfer.uid,
          phone: userTranfer.phone,
        ),
      );
      Navigator.push(context, route);
    });
    // if (user != null) {
    //   return readData(user).then((s) {
    //     Route route = MaterialPageRoute(builder: (c) => StoreHome());
    //     Navigator.pushReplacement(context, route);
    //   });
    // }
    // return createUserInFirestore();
  }

  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFFF1493),
        height: 1.5,
      ),
    );
  }

  // FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Đang xác thực ..",
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
      DocumentSnapshot snapshot = await Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .get();
      UserModel userTranfer = UserModel.fromDocument(snapshot);

      EcommerceApp.auth.signOut().then((c) {
        LoginAnimation(
          animationController: sanimationController.view,
          // userId: userTranfer.uid,
          // phone: userTranfer.phone,
        );
        _PlayAnimation();

        Route route = MaterialPageRoute(
          builder: (c) => VerifiedPhone(
            userId: userTranfer.uid,
            phone: userTranfer.phone,
          ),
        );
        Navigator.push(context, route);

        // var timer = Timer(Duration(seconds: 1), () {
        //   // Route route = MaterialPageRoute(
        //   //   builder: (c) => VerifiedPhone(
        //   //     userId: userTranfer.uid,
        //   //     phone: userTranfer.phone,
        //   //   ),
        //   // );
        //   // Navigator.pushReplacement(context, route);
        // });
        // timer.cancel();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => new VerifiedPhone(
        //           userId: userTranfer.uid,
        //           phone: userTranfer.phone,
        //         )));
      });
    }
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

/// textfromfield custom class
class textFromField extends StatelessWidget {
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;
  TextEditingController textController;

  textFromField(
      {this.email,
      this.icon,
      this.inputType,
      this.password,
      this.textController});

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
            controller: textController,
          ),
        ),
      ),
    );
  }
}

///buttonCustomFacebook class
// class buttonCustomFacebook extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//   }
// }

///buttonCustomGoogle class

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
          "Đăng nhập",
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

// Set Animation if user click button Login ==> route /verifiPhone

class LoginAnimation extends StatefulWidget {
  /// To set type animation and  start and end animation
  LoginAnimation({Key key, this.animationController, this.userId, this.phone})
      : animation = new Tween(
          end: 900.0,
          begin: 70.0,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.bounceInOut)),
        super(key: key);

  final AnimationController animationController;
  final Animation animation;
  final String userId;
  final String phone;

  Widget _buildAnimation(BuildContext context, Widget child) {
    /// Setting shape a animation
    return Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Container(
          height: animation.value,
          width: animation.value,
          decoration: BoxDecoration(
            color: Color(0xFF3B2E6F),
            shape: animation.value < 600 ? BoxShape.circle : BoxShape.rectangle,
          ),
        ));
  }

  @override
  _LoginAnimationState createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation> {
  @override

  /// To navigation after animation complete
  Widget build(BuildContext context) {
    widget.animationController.addListener(() {
      if (widget.animation.isCompleted) {
        Container(
          child: Image.asset("images/pexels-markus-spiske-2818573.jpg"),
        );
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => new VerifiedPhone(
        //           userId: widget.userId,
        //           phone: widget.phone,
        //         )));
      }
    });

    return new AnimatedBuilder(
      animation: widget.animationController,
      builder: widget._buildAnimation,
    );
  }
}
//------------------------------------------------------
