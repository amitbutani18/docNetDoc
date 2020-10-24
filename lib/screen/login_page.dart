import 'dart:convert';

import 'package:MiniProjectdoc/screen/signup_screen.dart';
import 'package:MiniProjectdoc/provider/signin_signup.dart';
import 'package:MiniProjectdoc/screen/dashbord.dart';
import 'package:http/http.dart' as http;
import 'package:MiniProjectdoc/widget/button.dart';
import 'package:MiniProjectdoc/widget/custom_snackbar.dart';
import 'package:MiniProjectdoc/widget/first.dart';
import 'package:MiniProjectdoc/widget/textLogin.dart';
import 'package:MiniProjectdoc/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isVer = false, _isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF6270DD), Color(0xFF6270DD).withOpacity(.7)]),
        ),
        child: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    VerticalText(),
                    TextLogin(),
                  ]),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _isLoad
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ButtonLogin(
                          callBack: () {
                            if (validateField(context)) {
                              _submit(context);
                            }
                          },
                        ),
                  FirstTime(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    setState(() {
      _isLoad = true;
    });
    final _authResult = await _auth.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString('uid', _authResult.user.uid);
    pre.setString('email', _authResult.user.email);

    print(_authResult.user.uid);
    print(_authResult.user.email);
    var uid = _authResult.user.uid;
    final url = 'https://miniproject-dc6b4.firebaseio.com/Doctors/$uid.json';
    final response = await http.get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    final status = map['verifyStatus'] as Map<String, dynamic>;
    print(map);

    _isVer = status['isVerify'];

    if (_isVer) {
      Navigator.of(context).pushReplacementNamed(Dashbord.routeName);
      final pre = await SharedPreferences.getInstance();
      pre.setBool('isLogin', true);
      setState(() {
        _isLoad = false;
      });
    } else {
      setState(() {
        _isLoad = false;
      });
      showAlertDialog(context);
    }
  }

  void signOut() async {
    final pre = await SharedPreferences.getInstance();
    pre.setBool('isLogin', false);
    await _auth.signOut();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        signOut();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thank You"),
      content: Text(
          "Your account in under verification, Try to login after 24 hour."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool validateField(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (emailController.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter email address', SnackBartype.nagetive);
      return false;
    }
    if (passwordController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter password', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
  }
}
