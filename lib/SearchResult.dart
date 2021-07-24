import 'dart:io';
import 'dart:typed_data';

import 'package:deaf_teacher/AddWord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'components/appBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'ShowChracters.dart';
import 'Hello.dart';
import 'check.dart';

class SearchResult extends StatefulWidget {
  SearchResult({Key? key, @required this.word}) : super(key: key);
  static String id = "SearchResult";
  String? word;
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void dispose() {
    // TODO: implement dispose
    path = null;
    result = [];
    print('search result screen disposed');
    super.dispose();
  }

  final wordscollections = FirebaseFirestore.instance.collection("words");
  final _firebaseStorage = FirebaseStorage.instance.ref();
  final _auth = FirebaseAuth.instance;
  String? path;
  List<Widget> result = [];
  bool _saving = true;
  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val && !val2) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<bool> getWordLink(String word) async {
    DocumentSnapshot? snap = await wordscollections.doc(word).get();
    if (!snap.exists || snap == null) {
      if (word.length < 4) return false;
      if (word[0] == 'ا' &&
          word[1] == 'ل' &&
          word[2] != 'ا' &&
          word[3] != 'ل') {
        // fix for better search
        String newword = word.substring(2);
        print(newword);
        setState(() {
          widget.word = newword;
        });
        return getWordLink(newword);
        //  getWordLink(newword);
      } else {
        print("word you search for not found");
        return false;
      }
    } else {
      String url = snap.get('link');
      String myWord = snap.get('word');
      String userid = snap.get('userid');
      path = url;
      print('word link = ' + url);
      print('word is = ' + myWord);
      print('userid = ' + userid);
      return true;
    }
  }

  Future<Uint8List?> getImageBytes(String path) async {
    Uint8List? data;
    await _firebaseStorage
        .child(path)
        .getData(100000000)
        .then((value) => data = value)
        .catchError((error) {});
    return data;
  }

  Future<String> getImage(String path) async {
    String link = await _firebaseStorage.child(path).getDownloadURL();
    print('download link = ' + link);
    return link;
  }

  List<Widget> buildFoundResult(var imageLink, String word) {
    List<Widget> list = [];
    list.add(
      Image.memory(
        imageLink,
        height: 300,
        repeat: ImageRepeat.repeat,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
    var converter = ShowCharacters(word: word);
    Widget r = converter.convert();
    list.add(SizedBox(height: 20));
    list.add(SafeArea(child: r));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(Center(
      child: Text(
        word,
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'Jomhuria',
        ),
      ),
    ));
    return list;
  }

  List<Widget> buildNotFoundResult() {
    List<Widget> list = [
      Image.asset(
        'assets/notFound.png',
        height: 400,
        width: 600,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'العودة',
              style: TextStyle(fontFamily: 'Jomhuria', fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AddWord.id);
            },
            child: Text(
              'إضافة الكلمة',
              style: TextStyle(fontFamily: 'Jomhuria', fontSize: 20),
            ),
          )
        ],
      ),
    ];
    return list;
  }

  @override
  Future<void> doit() async {
    bool? isFound = await getWordLink(widget.word!);
    if (isFound == null || isFound != true) {
      setState(() {
        result = buildNotFoundResult();
        _saving = false;
      });
    } else {
      // String? Imagelink = await getImage(path!);
      Uint8List? Imagelink = await getImageBytes(path!);
      setState(() {
        result = buildFoundResult(Imagelink!, widget.word!);
        _saving = false;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    checkauth();
    doit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarReusable(),
      body: ModalProgressHUD(
        child: ListView(
          children: result,
        ),
        inAsyncCall: _saving,
      ),
    );
  }
}
