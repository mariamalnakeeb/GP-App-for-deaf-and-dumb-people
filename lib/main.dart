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
import 'package:deaf_teacher/SearchByImage.dart';
import 'SearchByImageClasification.dart';
import 'SearchByOCR.dart';
import 'Dictionary.dart';
import 'userProfile.dart';
import 'ViewRequest.dart';
import 'Notifications.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: Hello.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        HomePageAdmin.id: (context) => HomePageAdmin(),
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
        userProfile.id: (context) => userProfile(),
        Notifications.id: (context) => Notifications(),
        Hello.id: (context) => Hello(),
        AddWord.id: (context) => AddWord(),
        Dictionary.id: (context) => Dictionary(),
        SearchByImage.id: (context) => SearchByImage(),
        SearchByImageClasification.id: (context) =>
            SearchByImageClasification(),
        SearchByOCR.id: (context) => SearchByOCR(),
        ValidateWords.id: (context) => ValidateWords(),
        SystemHome.id: (context) => SystemHome(),
        AddAdmin.id: (context) => AddAdmin(),
        RemoveAdmin.id: (context) => RemoveAdmin(),
        ViewRequest.id: (context) => ViewRequest(),
      },
    ),
  );
}
