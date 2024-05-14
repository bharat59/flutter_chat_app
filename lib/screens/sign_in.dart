import 'package:chat_app/helper/helper_fuctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class SignIn extends StatefulWidget {
  final Function() toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isLoading = false;
  QuerySnapshot? querySnapshot;

  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dbMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signIn() {
    if (formKey.currentState!.validate()) {

      HelperFunctions.setStringData(HelperFunctions.prefUserEmail, emailController.text);

      dbMethods.getUserByUserEmail(emailController.text).then((value) {
        querySnapshot = value;
        HelperFunctions.setStringData(HelperFunctions.prefUserName, querySnapshot?.docs[0]["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value) {
        if (value != null){
          HelperFunctions.setBooleanData(HelperFunctions.prefUserLogIn, true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
        ),
      ),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val.toString())
                              ? null
                              : "Please enter valid email.";
                        },
                        decoration: textFieldInputDecoration("Email"),
                        style: simpleTextStyle(),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (val) {
                          return (val?.length ?? 0) > 6
                              ? null
                              : "Please enter 6+ characters.";
                        },
                        decoration: textFieldInputDecoration("Password"),
                        style: simpleTextStyle(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Forgot Password?", style: simpleTextStyle())),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: signIn,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text(
                      "SignIn",
                      style: mediumTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(
                    "SignIn with Google",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",style: mediumTextStyle()),
                    GestureDetector(
                      onTap: widget.toggle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register Now",style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          decoration: TextDecoration.underline
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height:70)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
