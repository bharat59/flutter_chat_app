import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_fuctions.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dbMethods = DataBaseMethods();
  Stream? chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.documents[index]["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index]["chatRoomId"],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName =
        await HelperFunctions.getString(HelperFunctions.prefUserName) ?? "";
    setState(() {
      dbMethods.getChatRooms(Constants.myName).then((value) {
        setState(() {
          chatRoomStream = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              HelperFunctions.removeString(HelperFunctions.prefUserLogIn);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.logout)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  const ChatRoomTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // var chatRoomId = userName.toString().replaceAll("_", "").replaceAll(Constants.myName, "");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Conversation(
                chatRoomId: chatRoomId,
              ),
            ));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(userName.substring(0, 1).toUpperCase()),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
