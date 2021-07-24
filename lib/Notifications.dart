import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/appBar.dart';
import 'components/reusableRectangleCircularWidget.dart';
import 'Hello.dart';
import 'check.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);
  static String id = "Notifications";

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final userCollections = FirebaseFirestore.instance.collection("users");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarReusable(),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: userCollections
                    .doc(_auth.currentUser!.uid)
                    .collection('notifications')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  List<Widget> resultList = [];
                  var documents = snapshot.data!.docs;
                  String userID = _auth.currentUser!.uid;
                  int i = 1;
                  for (var document in documents) {
                    print(document.get('txt'));
                    resultList.add(new ReusableNotificationWidget(
                      content: document.get('txt'),
                      number: i,
                    ));
                    i++;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: resultList,
                  );
                })
          ],
        )));

    // This trailing comma makes auto-formatting nicer for build methods
  }

  // List<Widget> listOfNotification() {
  //   List<Widget> res = List();
  //   for (int i = 0; i < 15; i++) {
  //     res.add(ReusableNotificationWidget(
  //         content: 'hi there hi there hi there hi there hi there hi there ',
  //         number: i + 1));
  //   }
  //   return res;
  //
  // }

}
