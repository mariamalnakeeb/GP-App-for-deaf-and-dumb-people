import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io';

class uploader {
  uploader({this.file, this.word}) {
    Firebase.initializeApp();
  }
  final File? file;
  final String? word;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance.ref();
  final pendingwordscollections =
      FirebaseFirestore.instance.collection("pending_words");
  final wordscollections = FirebaseFirestore.instance.collection("words");
  final userscollections = FirebaseFirestore.instance.collection("users");
  UploadTask? _uploadTask;
  String? getUserID() {
    final User? user = auth.currentUser;
    final String? uid = user?.uid!;
    return uid;
    // here you write the codes to input the data into firestore
  }

  Future<bool> alreadyAvailable() async {
    var tmp = await wordscollections.doc(word).get();
    return tmp.exists;
  }

  Future<bool> upload() async {
    print("function upload called");
    String filepath = 'images/${DateTime.now()}.gif';
    _uploadTask = _firebaseStorage.child(filepath).putFile(file!);
    final TaskSnapshot? snapshot = await _uploadTask?.whenComplete(() {});
    if (snapshot != null) {
      String url = await snapshot!.ref.getDownloadURL();
      String userid = getUserID()!;
      print("user id: " + userid);
      print("uploaded file url " + url);
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'TypeOfUser',
      );

      dynamic results = await callable();
      var map = Map<String, bool>.from(results.data);
      if (map['AppAdmin']!) {
        await wordscollections
            .doc(word)
            .set({'link': filepath, 'userid': userid, 'word': word});
        var user = await userscollections.doc(userid).get();
        if (user.exists) {
          int accepted = int.parse(user.get('accepted'));
          accepted++;
          await userscollections
              .doc(userid)
              .update({'accepted': accepted.toString()});
        }
        return true;
      } else if (map['AppUser']!) {
        await pendingwordscollections
            .doc(word)
            .set({'link': filepath, 'userid': userid, 'word': word});
        return false;
      }
    }
    return false;
  }
}
