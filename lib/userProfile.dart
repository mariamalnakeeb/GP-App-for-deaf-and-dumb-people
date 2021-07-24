import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/appBar.dart';
import 'components/reusableRectangleCircularWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class userProfile extends StatefulWidget {
  userProfile({Key? key}) : super(key: key);
  static String id = "userProfile";

  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  bool isAppUser = false;
  bool isAppAdmin = false;
  bool isSent = false;
  String name = "";
  String email = "";
  String accepted = "";
  String rejected = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  final requestcollections = FirebaseFirestore.instance.collection('request');
  final userscollections = FirebaseFirestore.instance.collection("users");
  String getUserID() {
    final User? user = auth.currentUser;
    final String? uid = user?.uid!;
    return uid!;
    // here you write the codes to input the data into firestore
  }

  Future<void> RequestTobeAdmin() async {
    String id = getUserID();
    String date = DateTime.now().toString();
    await requestcollections.doc(id).set({'date': date});
  }

  Future<bool> isRequestSentBefore() async {
    String id = getUserID();
    String date = DateTime.now().toString();
    var data = await requestcollections.doc(id).get();
    if (data.exists)
      return true;
    else
      return false;
  }

  Future<Map<String, bool>> getUserType(String id) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'TypeOfUser',
    );

    dynamic results = await callable();
    var map = Map<String, bool>.from(results.data);
    return map;
  }

  void checker() async {
    String id = getUserID();
    if (id != null) {
      var map = await getUserType(id);
      await fetch(id);
      var sent = await isRequestSentBefore();
      setState(() {
        isSent = sent;
        if (map['AppUser']!)
          isAppUser = true;
        else if (map['AppAdmin']!) isAppAdmin = true;
      });
    }
  }

  Future<void> fetch(String id) async {
    var map = await userscollections.doc(id).get();
    setState(() {
      name = map.get('name');
      email = map.get('email');
      accepted = map.get('accepted');
      rejected = map.get('rejected');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print('userProfile');
    checker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: 401,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: Color(0xFFf36b7f),
          ),
          child: Column(
            children: [
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email!,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      Text(
                        isAppUser
                            ? 'normal user'
                            : isAppAdmin
                                ? 'admin user'
                                : '',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableCircularWidget(
                      widgetWidth: 170,
                      color: Color(0xFFf8cf61),
                      number: int.tryParse(accepted) ?? 0,
                      widgetTxt: 'الفيدوهات المقبولة'),
                  ReusableCircularWidget(
                      widgetWidth: 170,
                      color: Color(0xFF9fbfff),
                      number: int.tryParse(rejected) ?? 0,
                      widgetTxt: "الفيديوهات المرفوضة"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAppUser
                      ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xff82b5a5),
                          ),
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          margin: EdgeInsets.all(13),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(color: Colors.white),
                            ),
                            onPressed: isSent
                                ? null
                                : () async {
                                    await RequestTobeAdmin();
                                    setState(() {
                                      isSent = true;
                                    });
                                  },
                            child: Text(
                              'اريد ان اكون مشرف',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ]),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
