import 'package:deaf_teacher/AddWord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'components/appBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'Hello.dart';
import 'check.dart';

class EditWord extends StatefulWidget {
  EditWord({Key? key, @required this.word}) : super(key: key);
  static String id = "EditWord";
  String? word;
  @override
  _EditWordState createState() => _EditWordState();
}

class _EditWordState extends State<EditWord> {
  final _auth = FirebaseAuth.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  final wordscollection = FirebaseFirestore.instance.collection("words");
  final pendingwordscollections =
      FirebaseFirestore.instance.collection("pending_words");
  final _firebaseStorage = FirebaseStorage.instance.ref();
  String? path;
  List<Widget> result = [];
  bool _saving = true;
  DocumentSnapshot? doc;
  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    if (!val) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<bool> getWordLink(String word) async {
    DocumentSnapshot? snap = await pendingwordscollections.doc(word).get();
    if (!snap.exists || snap == null) {
      print("word you search for not found");
      return false;
    } else {
      doc = snap;
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
    list.add(SizedBox(
      height: 100,
    ));
    list.add(Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () async {
            await pendingwordscollections
                .doc(doc!.id)
                .delete()
                .then((value) async {
              print('word rejected');
              print('link to delete ' + doc!.get('link'));
              String link = await _firebaseStorage
                  .child(doc!.get('link'))
                  .getDownloadURL();
              FirebaseStorage.instance
                  .refFromURL(link)
                  .delete(); // delete the real image from storage
              var tmp = await userCollections.doc(doc!['userid']).get();
              if (tmp.exists && tmp != null) {
                int rejected = int.parse(tmp.get('rejected'));
                rejected++;
                await userCollections
                    .doc(doc!['userid'])
                    .update({'rejected': rejected.toString()});
                await userCollections
                    .doc(doc!['userid'])
                    .collection("notifications")
                    .add({
                  'txt': 'the word ${doc!.id} has been rejected by admins..',
                  'time': DateTime.now().toString()
                });
              }
              setState(() {
                result = [
                  SizedBox(
                    height: 150,
                  ),
                  Center(
                    child: Text(
                      "Word ${doc!.id} rejected successfully ",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ];
              });
            });
            // here the part where i need to add notifications to the user
          },
          child: Image(
            image: AssetImage("assets/no.png"),
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () async {
            await wordscollection.doc(doc!.id).set({
              'link': doc!['link'],
              'word': doc!['word'],
              'userid': doc!['userid']
            }).then((value) async {
              await pendingwordscollections
                  .doc(doc!.id)
                  .delete()
                  .then((value) async {
                print("word approved");
                var tmp = await userCollections.doc(doc!['userid']).get();
                if (tmp.exists && tmp != null) {
                  int accepted = int.parse(tmp.get('accepted'));
                  accepted++;
                  await userCollections
                      .doc(doc!['userid'])
                      .update({'accepted': accepted.toString()});
                  await userCollections
                      .doc(doc!['userid'])
                      .collection("notifications")
                      .add({
                    'txt': 'the word ${doc!.id} has been approved by admins ..',
                    'time': DateTime.now().toString()
                  });
                }
                setState(() {
                  result = [
                    SizedBox(
                      height: 150,
                    ),
                    Center(
                      child: Text(
                        "Word ${doc!.id} approved successfully ",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ];
                });
                // here the part where i need to add notifications to the user
              });
            });
          },
          child: Image(
            image: AssetImage("assets/yes.png"),
          ),
        ))
      ],
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

  @override
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
        child: Column(
          children: result,
        ),
        inAsyncCall: _saving,
      ),
    );
  }
}
