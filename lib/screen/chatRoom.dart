import 'package:MiniProjectdoc/screen/chat.dart';
import 'package:MiniProjectdoc/widget/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  String uid;

  String name = '', imageUrl;

  @override
  void initState() {
    // getUserName();
    getUserInfogetChats();
    super.initState();
  }

  Future<String> getUserName(String parUid) async {
    final list = await DatabaseMethods().getPartnerUserData(parUid);
    print(list[0]);
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    parUid:
                        snapshot.data.documents[index]['userName'].toString(),
                    chatRoomId: snapshot.data.documents[index]["chatRoomId"],
                    uid: uid,
                  );
                })
            : Container();
      },
    );
  }

  getUserInfogetChats() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    uid = pre.getString('uid');

    getUserChats(uid).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(snapshots);
        print("we got the data + ${chatRooms.toString()} this is name  $uid");
      });
    });
  }

  getUserChats(String itIsMyUid) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "assets/images/logo.png",
          // height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Search()));
      //   },
      // ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String parUid, uid;

  ChatRoomsTile({@required this.chatRoomId, @required this.parUid, this.uid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                      parUid: parUid,
                      myUid: uid,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(30)),
              child: Text(parUid,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(parUid,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
