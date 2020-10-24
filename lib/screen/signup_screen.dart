import 'dart:convert';

import 'package:MiniProjectdoc/screen/personal_detail_screen.dart';
import 'package:MiniProjectdoc/screen/profetional_detail.dart';
import 'package:MiniProjectdoc/widget/button.dart';
import 'package:MiniProjectdoc/widget/custom_snackbar.dart';
import 'package:MiniProjectdoc/widget/newEmail.dart';
import 'package:MiniProjectdoc/widget/newName.dart';
import 'package:MiniProjectdoc/widget/singup.dart';
import 'package:MiniProjectdoc/widget/textNew.dart';
import 'package:MiniProjectdoc/widget/userOld.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingupScreen extends StatefulWidget {
  static const routeName = 'signup';

  @override
  _SingupScreenState createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  _submit(BuildContext context) async {
    final _authResult = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    SharedPreferences pre = await SharedPreferences.getInstance();

    pre.setString('uid', _authResult.user.uid);
    pre.setString('email', _authResult.user.email);
    print(_authResult.user.uid);
    print(_authResult.user.email);
    final uid = _authResult.user.uid;
    print(uid);
    final url =
        'https://miniproject-dc6b4.firebaseio.com/Doctors/$uid/verifyStatus.json';
    await http.put(url,
        body: json.encode({
          'isVerify': false,
        }));

    Navigator.of(context).pushNamed(
      PersonalDetailScreen.routeName,
    );
  }

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
                  Row(
                    children: <Widget>[
                      SingUp(),
                      TextNew(),
                    ],
                  ),
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
                        controller: _emailController,
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
                        const EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        controller: _repeatPasswordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Re-enter Password',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ButtonLogin(callBack: () {
                    if (validateField(context)) {
                      _submit(context);
                    }
                  }),
                  UserOld(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateField(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter email address', SnackBartype.nagetive);
      return false;
    }
    if (_passwordController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter password', SnackBartype.nagetive);
      return false;
    }
    if (_passwordController.text != _repeatPasswordController.text) {
      CustomSnackBar(
          context, 'Please enter same password', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
  }
}
