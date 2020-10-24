import 'package:MiniProjectdoc/screen/login_page.dart';
import 'package:MiniProjectdoc/widget/navigationdrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashbord extends StatefulWidget {
  static const routeName = 'drawer-home';

  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await _auth.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DcoNet"),
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: RaisedButton(
          onPressed: signOut,
          child: Text("data"),
        ),
      ),
    );
  }
}
