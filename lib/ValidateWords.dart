// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditWord.dart';

class ValidateWords extends StatefulWidget {
  const ValidateWords({Key key}) : super(key: key);
  static String id = "ValidateWords";

  @override
  _ValidateWordsState createState() => _ValidateWordsState();
}

class _ValidateWordsState extends State<ValidateWords> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  int values = 0;
  int increment() {
    if (values < 3)
      values++;
    else
      values = 0;
  }

  final pendingwords = FirebaseFirestore.instance.collection("pending_words");
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
        body: Container(
          child: ListView(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: pendingwords.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    List<Widget> resultList = [];
                    List<Widget> rows = [];
                    var documents = snapshot.data.docs;
                    int i = 0;
                    int index = 0;
                    for (var doc in documents) {
                      if (doc.get('userid') != _auth.currentUser.uid) {
                        if (i % 3 == 0) {
                          index = resultList.length;
                          rows = [];
                          rows.add(Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditWord(word: doc.get('word'))));
                                print(doc.get('word') + ' Pressed');
                              },
                              child: Text(doc.get('word'),
                                  style: TextStyle(
                                      fontFamily: 'Jomhuria', fontSize: 30)),
                            ),
                          ));
                          resultList.add(Row(children: rows));
                          resultList.add(SizedBox(
                            height: 15,
                          ));
                        } else {
                          rows.add(Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditWord(word: doc.get('word'))));
                                print(doc.get('word') + ' Pressed');
                              },
                              child: Text(doc.get('word'),
                                  style: TextStyle(
                                      fontFamily: 'Jomhuria', fontSize: 30)),
                            ),
                          ));
                          resultList[index] = Row(children: rows);
                        }

                        i++;
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: resultList,
                    );
                  }),
            ],
          ),
        ));
  }
}
