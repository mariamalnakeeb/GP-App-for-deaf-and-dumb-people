import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'userinfo.dart';

class RemoveAdmin extends StatefulWidget {
  const RemoveAdmin({Key? key}) : super(key: key);
  static String id = "RemoveAdmin";
  @override
  _RemoveAdminState createState() => _RemoveAdminState();
}

class _RemoveAdminState extends State<RemoveAdmin> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  List<String>? usersId = [];
  void updateUsers() async {
    final snapshot = await userCollections.get();
    String userID = _auth.currentUser!.uid;
    for (var doc in snapshot.docs) {
      if (doc.id != userID) {
        final userClaim = await getUserType(doc.id);
        if (userClaim != null) {
          if (userClaim!['AppAdmin']!) {
            setState(() {
              usersId!.add(doc.id);
            });
          }
        }
      }
    }
  }

  Future<void> setAppUser(String id) async {
    Map<String, String> data = new Map();
    data['id'] = id;
    print('remove user admin Privilege of id =' + data.toString());
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'setAppUserClaim',
    );

    await callable.call(data);
  }

  Future<Map<String, bool>> getUserType(String id) async {
    print("RemoveAdmin");
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
              'Application Admins',
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
              stream: userCollections.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<Widget> resultList = [];
                var documents = snapshot.data!.docs;
                String userID = _auth.currentUser!.uid;
                for (var document in documents) {
                  if (document.id != userID &&
                      (usersId!.indexOf(document.id) >= 0)) {
                    resultList.add(User_info(
                      name: document.get('name'),
                      email: document.get('email'),
                      numOfaccepted: document.get('accepted'),
                      numOfrejected: document.get('rejected'),
                      txt: 'make Admin as user',
                      onPressed: () async {
                        await setAppUser(document.id);
                        await userCollections
                            .doc(document.id)
                            .collection("notifications")
                            .add({
                          'txt':
                              'sorry you lost your admin privilege and become normal user ',
                          'time': DateTime.now().toString()
                        });
                        setState(() {
                          usersId!.remove(document.id);
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
