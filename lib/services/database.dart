import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  //get userlist per name
  getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  // upload user to db
  uploadUserToServer(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  //create chat room
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((onError) {
      print(onError.toString());
    });
  }

  //get conversation for user
  addConversationsMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((error) => print(error.toString()));
  }

  //get chat messages
  getConversationsMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  //get chat-rooms list
  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userName)
        .snapshots();
  }
}
