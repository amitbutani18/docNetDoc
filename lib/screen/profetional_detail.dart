import 'dart:convert';

import 'package:MiniProjectdoc/screen/login_page.dart';
import 'package:MiniProjectdoc/provider/degree.dart';
import 'package:MiniProjectdoc/provider/signin_signup.dart';
import 'package:MiniProjectdoc/screen/dashbord.dart';
import 'package:MiniProjectdoc/widget/button.dart';
import 'package:MiniProjectdoc/widget/custom_snackbar.dart';
import 'package:MiniProjectdoc/widget/textnew2.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/registration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfessionalDetail extends StatefulWidget {
  static const routeName = 'professional-detail';

  @override
  _ProfessionalDetailState createState() => _ProfessionalDetailState();
}

class _ProfessionalDetailState extends State<ProfessionalDetail> {
  List _myActivities;

  TextEditingController _registrationNumber = TextEditingController();
  TextEditingController _universityContrller = TextEditingController();
  TextEditingController _yerOfRegistration = TextEditingController();

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    SharedPreferences pre = await SharedPreferences.getInstance();
    final uid = pre.getString('uid');
    print(uid);
    final url =
        'https://miniproject-dc6b4.firebaseio.com/Doctors/$uid/profesionalDetails.json';
    await http.put(url,
        body: json.encode({
          'RegNumber': _registrationNumber.text,
          'UniName': _universityContrller.text,
          'YearOfReg': DateTime.now().toIso8601String(),
          'Qulifications': _myActivities,
          'data': true,
        }));

    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    final degreeList = Provider.of<Degree>(context).items;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
        child: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Registration(),
                      TextNew2(),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _registrationNumber,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Registration_No :',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _universityContrller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'University Name :',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _yerOfRegistration,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Year of Reg :',
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
                    child: MultiSelectFormField(
                      fillColor: Colors.transparent,
                      autovalidate: false,
                      title: Text(
                        'Qualifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.length == 0) {
                      //     return 'Please select one or more options';
                      //   }
                      //   return null;
                      // },
                      dataSource: degreeList,
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text(
                        'Please choose one or more',
                        style: TextStyle(color: Colors.white),
                      ),
                      initialValue: _myActivities,
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _myActivities = value;
                        });
                      },
                    ),
                  ),
                  ButtonLogin(callBack: () {
                    if (validateField(context)) {
                      _submit(context);
                    }
                  }),
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
    if (_registrationNumber.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter registration number', SnackBartype.nagetive);
      return false;
    }
    if (_universityContrller.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter university name', SnackBartype.nagetive);
      return false;
    }
    if (_yerOfRegistration.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter year of registration', SnackBartype.nagetive);
      return false;
    }
    if (_myActivities.length == 0) {
      CustomSnackBar(
          context, 'Select one or more qulifications', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
  }
}
