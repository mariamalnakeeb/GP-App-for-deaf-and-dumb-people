// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/appBar.dart';
import 'HomeUtilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Hello.dart';
import 'check.dart';

class HomePageAdmin extends StatefulWidget {
  @override
  _HomePageAdminState createState() => _HomePageAdminState();
  static String id = "HomePageAdmin";
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final _auth = FirebaseAuth.instance;
  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    //bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val) {
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
        isAdmin: true,
      ),
    );
  }
}
