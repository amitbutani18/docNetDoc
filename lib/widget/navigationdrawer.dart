import 'package:MiniProjectdoc/screen/chatRoom.dart';
import 'package:MiniProjectdoc/widget/createDrawerBodyItem.dart';
import 'package:MiniProjectdoc/widget/createDrawerHeader.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          GestureDetector(
            child: createDrawerBodyItem(icon: Icons.home, text: 'Home'),
          ),
          createDrawerBodyItem(icon: Icons.account_circle, text: 'Profile'),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ChatRoom()));
              },
              child:
                  createDrawerBodyItem(icon: Icons.event_note, text: 'Chat')),
          Divider(),
          createDrawerBodyItem(
              icon: Icons.notifications_active, text: 'Notifications'),
          createDrawerBodyItem(icon: Icons.contact_phone, text: 'Contact Info'),
          ListTile(
            title: Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
