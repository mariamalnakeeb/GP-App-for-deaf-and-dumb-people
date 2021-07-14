import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class uploader {
  uploader({this.file, this.word}) {
    Firebase.initializeApp();
  }
  final File? file;
  final String? word;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance.ref();
  final userCollections =
      FirebaseFirestore.instance.collection("pending_words");
  final userCollectionsAdmin = FirebaseFirestore.instance.collection("words");
  UploadTask? _uploadTask;
  String? getUserID() {
    final User? user = auth.currentUser;
    final String? uid = user?.uid!;
    return uid;
    // here you write the codes to input the data into firestore
  }

  Future<void> upload() async {
    print("function upload called");
    String filepath = 'images/${DateTime.now()}.gif';
    _uploadTask = _firebaseStorage.child(filepath).putFile(file!);
    final TaskSnapshot? snapshot = await _uploadTask?.whenComplete(() {});
    if (snapshot != null) {
      String url = await snapshot!.ref.getDownloadURL();
      String userid = getUserID()!;
      print("user id: " + userid);
      print("uploaded file url " + url);
      await userCollections
          .doc(word)
          .set({'link': filepath, 'userid': userid, 'word': word});
    }
  }
}
