import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/general_utils.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchValue = TextEditingController();
  DataBaseMethods dbMethods = DataBaseMethods();
  QuerySnapshot? searchSnapshot;

  initSearch() {
    dbMethods.getUserByUserName(searchValue.text).then((value) {
      print(value.toString());
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  ///create chat-room anf send user to chatting screen
  createChatRoomAndStartConversation({required String userName}) {

    if (userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId":chatRoomId
      };
      dbMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId: chatRoomId)));
    } else {
      print("you can not send message to yourself");
    }
  }

  Widget SearchTiles({required String userName, required String userEmail}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle()),
              Text(userEmail, style: simpleTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("Message"),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.separated(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => SearchTiles(
              userName: searchSnapshot!.docs[index]["name"],
              userEmail: searchSnapshot!.docs[index]["email"],
            ), separatorBuilder: (BuildContext context, int index) { return Divider(); },
          )
        : Container();
  }

  @override
  void initState() {
    // initSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchValue,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initSearch();
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


//
// class SearchListItem extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//
//   const SearchListItem({Key key, this.userName, this.userEmail})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(userName, style: simpleTextStyle()),
//               Text(userEmail, style: simpleTextStyle()),
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(30)),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Text("Message"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
