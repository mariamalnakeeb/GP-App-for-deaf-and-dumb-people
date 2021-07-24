import 'dart:ui';
import 'components/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'DictionaryResult.dart';
import 'check.dart';
import 'Hello.dart';

class Dictionary extends StatefulWidget {
  Dictionary({Key? key, this.title}) : super(key: key);
  static String id = "Dictionary";

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  final _auth = FirebaseAuth.instance;
  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val && !val2) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  String alpha = "ابتثجحخدذرزسشصضطظعغفقكلمنهوي";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkauth();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBarReusable(),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listOfUsers()),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> listOfUsers() {
    List<Widget> res = [];
    for (int i = 0; i < 28; i++) {
      res.add(Container(
          height: 100,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                  image: AssetImage('dics/$i.png'), fit: BoxFit.fill)),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DictionaryResult(
                            char: alpha[i],
                          )));
              print('charachter ${alpha[i]} selected');
            },
            child: Text(''),
          )));
    }
    return res;
  }
}
