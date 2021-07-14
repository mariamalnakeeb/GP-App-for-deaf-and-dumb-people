// @dart=2.9
import 'package:deaf_teacher/AddAdmin.dart';
import 'package:deaf_teacher/AddWord.dart';
import 'package:deaf_teacher/Hello.dart';
import 'package:deaf_teacher/HomePageAdmin.dart';
import 'package:deaf_teacher/RemoveAdmin.dart';
import 'package:deaf_teacher/ValidateWords.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'sign_in.dart';
import 'Sign_up.dart';
import 'AddWord.dart';
import 'SystemHome.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: Hello.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        HomePageAdmin.id: (context) => HomePageAdmin(),
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
        Hello.id: (context) => Hello(),
        AddWord.id: (context) => AddWord(),
        ValidateWords.id: (context) => ValidateWords(),
        SystemHome.id: (context) => SystemHome(),
        AddAdmin.id: (context) => AddAdmin(),
        RemoveAdmin.id: (context) => RemoveAdmin(),
      },
    ),
  );
}
