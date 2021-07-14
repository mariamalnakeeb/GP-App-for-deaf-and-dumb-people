import 'package:deaf_teacher/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
  static final String id = "Signup";
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

  final fire = Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");

  Future<void> SignupToColud(
      {@required String name = "",
      @required String email = "",
      @required String pass = ""}) async {
    try {
      //  await Firebase.initializeApp();
      await Firebase.initializeApp();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        if (value.user != null) {
          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
            'setUserClaim',
          );
          dynamic results = await callable();
          String userId = value.user!.uid;
          await userCollections.doc(userId).set({'name': name, 'email': email});
          await userCollections
              .doc(userId)
              .collection("notifications")
              .add({'txt': 'welcome to Deaf Arabic Sign language app!'});
        } else {
          throw Error();
        }
      });
      // first sign up to cloud if success

      //then add to users collections
      // then return userid // object
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> vals = ["", "", "", ""];
  bool checkVals(
      {@required String name = "",
      @required String email = "",
      @required String pass1 = "",
      @required String pass2 = ""}) {
    bool result = true;
    if (name.length < 5) {
      vals[0] = "name should be 5 charaters or more";
      result = false;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      vals[1] = "type correct email address ";
      result = false;
    }
    if (pass1.length < 6) {
      vals[2] = "password should be 6 length atleast";
      result = false;
    }
    if (pass1 != pass2) {
      vals[2] = vals[3] = "password should be same";
      result = false;
    }
    return result;
  }

  @override
  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController Pass1Controller = TextEditingController();
  TextEditingController Pass2Controller = TextEditingController();
  String name = "";
  String email = "";
  String pass1 = "";
  String pass2 = "";

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
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
              child: TextField(
                controller: NameController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: "enter your name",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
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
                keyboardType: TextInputType.emailAddress,
                controller: EmailController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
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
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextField(
                controller: Pass1Controller,
                textAlign: TextAlign.left,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "enter your password",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 15),
              child: Text(
                vals[2],
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextField(
                controller: Pass2Controller,
                textAlign: TextAlign.left,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "repeat your password",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 15),
              child: Text(
                vals[3],
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
            Column(
              children: [
                Container(
                  height: 50.0,
                  margin: EdgeInsets.all(10),
                  child: RaisedButton(
                    onPressed: () {
                      name = NameController.text;
                      email = EmailController.text;
                      pass1 = Pass1Controller.text;
                      pass2 = Pass2Controller.text;
                      NameController.text = "";
                      EmailController.text = "";
                      Pass1Controller.text = "";
                      Pass2Controller.text = "";
                      setState(() {
                        vals = ["", "", "", ""];
                        bool b = checkVals(
                            name: name,
                            email: email,
                            pass1: pass1,
                            pass2: pass2);
                        if (b) {
                          SignupToColud(name: name, email: email, pass: pass1);
                          Navigator.pushNamed(context, HomePage.id);
                        }
                      });
                      print('name = $name');
                      print('email = $email');
                      print('pass1 = $pass1');
                      print('pass2 = $pass2');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Color(0xFFA4C9BE),
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
              ],
            ),
          ],
        ));
  }
}
