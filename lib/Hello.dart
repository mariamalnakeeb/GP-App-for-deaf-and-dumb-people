import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'Sign_up.dart';
import 'package:firebase_core/firebase_core.dart';

class Hello extends StatelessWidget {
  const Hello({Key? key}) : super(key: key);
  static String id = "Hello";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              //flex: 2,
              child: Container(
                child: Image(
                  width: double.infinity,
                  image: AssetImage("assets/Home.png"),
                ),
              ),
            ),
            Container(
              height: 50.0,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () async {
                  await Firebase.initializeApp();
                  Navigator.pushNamed(context, SignUp.id);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xFFA2BFF7),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "تسجيل حساب جديد",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50.0,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () async {
                  await Firebase.initializeApp();
                  Navigator.pushNamed(context, SignIn.id);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xFFA2BFF7), //Color(0xFFA4C9BE)
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      " تسجيل دخول ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
