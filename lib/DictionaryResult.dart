import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'components/appBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SearchResult.dart';
import 'check.dart';
import 'Hello.dart';

class DictionaryResult extends StatefulWidget {
  DictionaryResult({Key? key, @required this.char}) : super(key: key);
  String? char;
  static String id = "DictionaryResult";

  @override
  _DictionaryResultState createState() => _DictionaryResultState();
}

class _DictionaryResultState extends State<DictionaryResult> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final wordsCollections = FirebaseFirestore.instance.collection("words");
  int _counter = 0;
  var arr = [
    0xff082b5a5,
    0xfff36d81,
    0xff9fbfff,
    0xfff8cf5e,
  ];

  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val && !val2) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _incrementCounter() {
    if (_counter == 3) {
      _counter = 0;
    } else {
      _counter++;
    }
  }

  bool firstChar(String word, String second) {
    if (word == 'ا') {
      if (second == 'ا' || second == 'إ' || second == 'أ' || second == 'آ')
        return true;
      else
        return false;
    } else {
      if (word == second)
        return true;
      else
        return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkauth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarReusable(),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: wordsCollections.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<Widget> resultList = [];
                var documents = snapshot.data!.docs;
                for (var document in documents) {
                  if (firstChar(widget.char!, document.id[0])) {
                    resultList.add(Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(arr[_counter]),
                      ),
                      child: TextButton(
                        child: Text(
                          document.id,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchResult(word: document.id)));
                        },
                      ),
                    ));
                    resultList.add(SizedBox(
                      height: 5,
                    ));
                    _incrementCounter();
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: resultList,
                );
              })
        ],
      ),
    );
  }
}
