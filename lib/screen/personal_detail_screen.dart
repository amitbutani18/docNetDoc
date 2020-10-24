import 'dart:convert';
import 'dart:io';

import 'package:MiniProjectdoc/screen/profetional_detail.dart';
import 'package:MiniProjectdoc/widget/button.dart';
import 'package:MiniProjectdoc/widget/custom_snackbar.dart';
import 'package:MiniProjectdoc/widget/registration.dart';
import 'package:MiniProjectdoc/widget/textnew2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailScreen extends StatefulWidget {
  static const routeName = 'personal-detail';
  @override
  _PersonalDetailScreenState createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
  final _nameController = TextEditingController();
  final _fathernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _adressController = TextEditingController();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    SharedPreferences pre = await SharedPreferences.getInstance();
    final uid = pre.getString('uid');
    final email = pre.getString('email');
    print(uid);
    final url =
        'https://miniproject-dc6b4.firebaseio.com/Doctors/$uid/personalDetails.json';
    final ref = FirebaseStorage.instance
        .ref()
        .child('doctor_image')
        .child(uid + '.jpg');
    await ref.putFile(_image).onComplete;
    final imageUrl = await ref.getDownloadURL();
    await http.put(url,
        body: json.encode({
          'uid' : uid,
          'imageUrl': imageUrl,
          'Email': email,
          'Name': _nameController.text,
          'FatherName': _fathernameController.text,
          'Dob': selectedDate.toIso8601String(),
          'Address': _adressController.text,
          'data': true,
        }));
    Navigator.of(context).pushNamed(
      ProfessionalDetail.routeName,
    );
  }

  DateTime selectedDate = DateTime.now();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1940),
        lastDate: DateTime(2021));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(
                        width: 100,
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white),
                            image: DecorationImage(
                                image: _image == null
                                    ? CachedNetworkImageProvider(
                                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png')
                                    : FileImage(_image)),
                          ),
                        ),
                      ),
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Name :',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
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
                        controller: _fathernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Father Name :',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          enabled: false,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: _dobController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Dob : ${selectedDate}',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        controller: _adressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Adress :',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ButtonLogin(callBack: () {
                    if (validateField(context)) {
                      _submit();
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
    if (_nameController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter your name', SnackBartype.nagetive);
      return false;
    }
    if (_fathernameController.text.isEmpty) {
      CustomSnackBar(
          context, 'Please enter your father name', SnackBartype.nagetive);
      return false;
    }
    if (_adressController.text.isEmpty) {
      CustomSnackBar(context, 'Please enter address', SnackBartype.nagetive);
      return false;
    } else {
      return true;
    }
  }
}
