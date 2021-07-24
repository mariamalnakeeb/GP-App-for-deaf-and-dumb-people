import 'package:deaf_teacher/AddAdmin.dart';
import 'package:deaf_teacher/Hello.dart';
import 'package:deaf_teacher/RemoveAdmin.dart';
import 'package:deaf_teacher/ViewRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SystemHome extends StatefulWidget {
  const SystemHome({Key? key}) : super(key: key);
  static String id = "SystemHome";
  @override
  _SystemHomeState createState() => _SystemHomeState();
}

class _SystemHomeState extends State<SystemHome> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
        ],
        title: Center(
            child: Text(
          "Deaf Teacher",
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier New',
          ),
        )),
        backgroundColor: Color(0xFFA4C9BE),
        textTheme: TextTheme(),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  ' System Admin ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddAdmin.id);
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
                      "Add App Admin",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              RaisedButton(
                onPressed: () {
                  print('Remove admin tapped');
                  Navigator.pushNamed(context, RemoveAdmin.id);
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
                      "Remove App Admin",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              RaisedButton(
                onPressed: () {
                  print('view Requests to be admins');
                  Navigator.pushNamed(context, ViewRequest.id);
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
                      "View Requests to be admins",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
