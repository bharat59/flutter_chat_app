import 'package:chat_app/helper/helper_fuctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class SignUp extends StatefulWidget {
  final Function() toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dbMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {

      Map<String, String> userMap ={
        "name":usernameController.text,
        "email":emailController.text
      };
      
      setState(() {
        isLoading = true;
      });

      //set data to pref
      HelperFunctions.setStringData(HelperFunctions.prefUserEmail, emailController.text);
      HelperFunctions.setStringData(HelperFunctions.prefUserName, usernameController.text);

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        // print("${value.uid}");
        dbMethods.uploadUserToServer(userMap);
        HelperFunctions.setBooleanData(HelperFunctions.prefUserLogIn, true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
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
                              validator: (val) {
                                return (val?.isEmpty ?? false) || (val?.length ?? 0) < 2
                                    ? "Please enter username."
                                    : null;
                              },
                              controller: usernameController,
                              decoration: textFieldInputDecoration("Username"),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val.toString())
                                    ? null
                                    : "Please enter valid email.";
                              },
                              controller: emailController,
                              decoration: textFieldInputDecoration("Email"),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return (val?.length ?? 0) > 6
                                    ? null
                                    : "Please enter 6+ characters.";
                              },
                              controller: passwordController,
                              decoration: textFieldInputDecoration("Password"),
                              style: simpleTextStyle(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text("Forgot Password?",
                                style: simpleTextStyle())),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          //TODO
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "SignUp",
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
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "SignUp with Google",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: mediumTextStyle()),
                          GestureDetector(
                            onTap: widget.toggle,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "SignIn Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 70)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
