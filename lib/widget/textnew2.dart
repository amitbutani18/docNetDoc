import 'package:flutter/material.dart';

class TextNew2 extends StatefulWidget {
  @override
  _TextNew2State createState() => _TextNew2State();
}

class _TextNew2State extends State<TextNew2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
      child: Container(
        //color: Colors.green,
        height: 200,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
            ),
            Center(
              child: Text(
                'Personal details',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
