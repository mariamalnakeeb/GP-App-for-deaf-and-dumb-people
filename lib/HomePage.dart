// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/appBar.dart';
import 'HomeUtilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Hello.dart';
import 'check.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  static String id = "HomePage";
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  var checker = check();
  void checkauth() async {
    //bool val = await checker.doYouHaveRightPermission("AppAdmin");
    bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val2) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarReusable(),
      body: HomeWidget(
        isAdmin: false,
      ),
    );
  }
}
