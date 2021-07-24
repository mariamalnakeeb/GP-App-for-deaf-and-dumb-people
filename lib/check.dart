import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class check {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogin() {
    var user = auth.currentUser;
    if (user != null)
      return true;
    else
      return false;
  }

  Future<bool> doYouHaveRightPermission(String permission) async {
    if (isLogin()) {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'TypeOfUser',
      );

      dynamic results = await callable();
      var map = Map<String, bool>.from(results.data);
      bool value = map[permission]!;
      return value;
    } else
      return false;
  }
}
