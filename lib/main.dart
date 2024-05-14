import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_fuctions.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLogin = false;

  @override
  void initState() {
    getLogInState();
    super.initState();
  }

  getLogInState() async {
    await HelperFunctions.getBoolean(HelperFunctions.prefUserLogIn)
        .then((value) {
      setState(() {
        print(value);
        isUserLogin = value ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isUserLogin ? ChatRoom() : Authenticate());
  }
}

class Blank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
