import 'package:deaf_teacher/AddWord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  String? path;
  List<Widget> result = [];
  bool _saving = true;
  Future<bool> getWordLink(String word) async {
    DocumentSnapshot? snap = await wordscollections.doc(word).get();
    if (!snap.exists || snap == null) {
      print("word you search for not found");
      return false;
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

  Future<String> getImage(String path) async {
    String link = await _firebaseStorage.child(path).getDownloadURL();
    print('download link = ' + link);
    return link;
  }

  List<Widget> buildFoundResult(String imageLink, String word) {
    List<Widget> list = [];
    // list.add(Image.network(imageLink, fit: BoxFit.fill));
    list.add(
      Image.network(
        imageLink,
        repeat: ImageRepeat.repeat,
        width: double.infinity,
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Column(children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded.toDouble() /
                        loadingProgress.expectedTotalBytes!.toDouble()
                    : null,
              ),
            ),
          ]);
        },
      ),
    );
    list.add(SizedBox(height: 20));
    list.add(Center(
      child: Text(
        word,
        style: TextStyle(
          fontSize: 30,
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
      String? Imagelink = await getImage(path!);
      setState(() {
        result = buildFoundResult(Imagelink!, widget.word!);
        _saving = false;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    // bool? isFound = await getWordLink(widget.word!);
    // if (isFound == null || isFound != true) {
    //   setState(() {
    //     result = buildNotFoundResult();
    //   });
    // } else {
    //   Imagelink = await getImage(path!);
    //   setState(() {
    //     result = buildFoundResult(Imagelink!, widget.word!);
    //   });
    // }
    doit();
    super.initState();
  }

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
      body: ModalProgressHUD(
        child: Column(
          children: result,
        ),
        inAsyncCall: _saving,
      ),
    );
  }
}
