import 'package:deaf_teacher/HomePage.dart';
import 'package:deaf_teacher/HomePageAdmin.dart';
import 'package:deaf_teacher/SystemHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
  static final String id = "Signin";
}

List<String> vals = ["", ""];
bool checkVals({
  @required String email = "",
  @required String pass = "",
}) {
  bool result = true;
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (!emailValid) {
    vals[0] = "type correct email address ";
    result = false;
  }
  if (pass.length < 6) {
    vals[1] = "password should be 6 length atleast";
    result = false;
  }
  return result;
}

class _SignInState extends State<SignIn> {
  final fire = Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  TextEditingController PassController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  String? email;
  String? password;
  @override
  void initState() {
    // TODO: implement initState
    vals = ["", ""];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Deaf Teacher",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier New',
            ),
          )),
          backgroundColor: Color(0xFFA4C9BE),
          textTheme: TextTheme(),
        ),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
            child: TextField(
              controller: EmailController,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: "enter your email",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 15),
            child: Text(
              vals[0],
              style: TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: TextField(
              controller: PassController,
              textAlign: TextAlign.left,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 15),
            child: Text(
              vals[1],
              style: TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(140, 0, 140, 15),
            child: Divider(
              color: Colors.red,
              height: 2,
              thickness: 3.0,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            height: 50.0,
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () async {
                password = PassController.text;
                email = EmailController.text;
                EmailController.text = "";
                PassController.text = "";
                bool b = false;
                setState(() {
                  vals = ["", ""];
                  b = checkVals(email: email!, pass: password!);
                });
                if (b) {
                  try {
                    print('email = $email');
                    print('password = $password');
                    await Firebase.initializeApp();
                    await _auth
                        .signInWithEmailAndPassword(
                            email: email!, password: password!)
                        .then((value) async {
                      if (value.user != null) {
                        HttpsCallable callable =
                            FirebaseFunctions.instance.httpsCallable(
                          'TypeOfUser',
                        );

                        dynamic results = await callable();
                        var map = Map<String, bool>.from(results.data);
                        //    print('is he SystemAdmin ${map['SystemAdmin']!}');
                        //  print('is he AppAdmin ${map['AppAdmin']!}');
                        //print('is he AppUser ${map['AppUser']!}');
                        if (map['SystemAdmin']!) {
                          print("welcome System Admin");
                          Navigator.pushNamed(context, SystemHome.id);
                        } else if (map['AppAdmin']!) {
                          Navigator.pushNamed(context, HomePageAdmin.id);
                        } else {
                          Navigator.pushNamed(context, HomePage.id);
                        }

                        // }
                      } else {
                        throw Error();
                      }
                    }).onError((error, stackTrace) {
                      setState(() {
                        vals[0] = "${error.toString()}";
                        vals[1] = "Wrong Email or password";
                      });
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: Color(0xFFA4C9BE),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "تسجيل دخول",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
