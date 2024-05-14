import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String? chatRoomId;

  Conversation({this.chatRoomId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  int? totalMessage;
  DataBaseMethods dbMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream? chatMessageStream;
  ScrollController _scrollController = new ScrollController();

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    // setState(() {
                    //   totalMessage = snapshot.data.documents.length;
                    // });
                    return MessageTile(
                        message: snapshot.data.documents[index]["message"],
                        isSendByMe: snapshot.data.documents[index]
                                ["sendBy"] ==
                            Constants.myName);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      dbMethods.addConversationsMessages(widget.chatRoomId.toString(), messageMap);
      messageController.text = "";
      // setState(() {
      //   _scrollController.animateTo(
      //     chatMessageStream.length as double,
      //     curve: Curves.easeOut,
      //     duration: const Duration(milliseconds: 300),
      //   );
      // });
    }
  }

  @override
  void initState() {
    DataBaseMethods().getConversationsMessages(widget.chatRoomId.toString()).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          widget.chatRoomId.toString().replaceAll("_", "").replaceAll(Constants.myName, "")
      ),),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "send message...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.orange,
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String? message;
  final bool isSendByMe;

  MessageTile({this.message, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC),
                      ]
                    : [
                        const Color(0x1AFFFFFF),
                        const Color(0x1AFFFFFF),
                      ]),
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
        child: Text(
          message.toString(),
          style: simpleTextStyle(),
        ),
      ),
    );
  }
}
