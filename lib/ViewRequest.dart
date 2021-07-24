import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'userinfo.dart';

class ViewRequest extends StatefulWidget {
  ViewRequest({Key? key}) : super(key: key);
  static String id = "ViewRequest";

  @override
  _ViewRequestState createState() => _ViewRequestState();
}

class _ViewRequestState extends State<ViewRequest> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final requestCollections = FirebaseFirestore.instance.collection("request");
  final userCollections = FirebaseFirestore.instance.collection("users");
  Map<String, DocumentSnapshot> users = Map();
  void updateUsers() async {
    final snapshot = await userCollections.get();
    String userID = _auth.currentUser!.uid;
    for (var doc in snapshot.docs) {
      if (doc.id != userID) {
        final userClaim = await getUserType(doc.id);
        if (userClaim != null) {
          if (userClaim!['AppUser']!) {
            setState(() {
              users![doc.id] = doc;
            });
          }
        }
      }
    }
  }

  Future<Map<String, bool>> getUserType(String id) async {
    Map<String, String> data = new Map();
    data['id'] = id;
    print(data.toString());
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'TypeOfUserById',
    );

    dynamic results = await callable.call(data);
    var map = Map<String, bool>.from(results.data);
    print(map.toString());
    return map;
  }

  Future<void> setAppAdmin(String id) async {
    Map<String, String> data = new Map();
    data['id'] = id;
    print('make user admin of id =' + data.toString());
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'setAppAdminClaim',
    );

    await callable.call(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUsers();
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
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              'Requests to be Admin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: requestCollections.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<Widget> resultList = [];
                var documents = snapshot.data!.docs;
                String userID = _auth.currentUser!.uid;
                for (var document in documents) {
                  if (document.id != userID && users.containsKey(document.id)) {
                    resultList.add(User_info2(
                      name: users[document.id]!.get('name'),
                      email: users[document.id]!.get('email'),
                      numOfaccepted: users[document.id]!.get('accepted'),
                      numOfrejected: users[document.id]!.get('rejected'),
                      onAccept: () async {
                        await setAppAdmin(document.id);
                        requestCollections.doc(document.id).delete();
                        await userCollections
                            .doc(document.id)
                            .collection("notifications")
                            .add({
                          'txt':
                              'congratulations your request to be Admin approved successfully!',
                          'time': DateTime.now().toString()
                        });
                        setState(() {
                          users.remove(document.id);
                        });
                        updateUsers();
                      },
                      onReject: () async {
                        requestCollections.doc(document.id).delete();
                        await userCollections
                            .doc(document.id)
                            .collection("notifications")
                            .add({
                          'txt':
                              'sorry your request to be Admin has been rejected !',
                          'time': DateTime.now().toString()
                        });
                        setState(() {
                          users.remove(document.id);
                        });
                        updateUsers();
                      },
                    ));
                    resultList.add(SizedBox(
                      height: 5,
                    ));
                  }
                }
                return Column(
                  children: resultList,
                );
              })
        ],
      ),
    );
  }
}
