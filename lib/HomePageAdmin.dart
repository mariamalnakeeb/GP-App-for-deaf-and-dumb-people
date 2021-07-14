// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomeUtilities.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({Key key}) : super(key: key);
  static String id = "HomePageAdmin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        textTheme: TextTheme(),
      ),
      body: HomeWidget(
        isAdmin: true,
      ),
    );
  }
}
