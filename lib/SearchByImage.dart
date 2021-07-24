import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/appBar.dart';
import 'SearchByImageClasification.dart';
import 'SearchByOCR.dart';
import 'check.dart';
import 'Hello.dart';

class SearchByImage extends StatefulWidget {
  SearchByImage({Key? key}) : super(key: key);
  static String id = "SearchByImage";

  @override
  _SearchByImageState createState() => _SearchByImageState();
}

class _SearchByImageState extends State<SearchByImage> {
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
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'البحث بالصور بستخدام ',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 300,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchByImageClasification.id);
                print('تصنيف الصور');
                //Navigator.pushNamed(context, AddAdmin.id);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: Color(0xFFA4C9BE),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "تصنيف الصور",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            RaisedButton(
              onPressed: () {
                print('التعرف الضوئي على الحروف');
                Navigator.pushNamed(context, SearchByOCR.id);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: Color(0xFFA4C9BE),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "التعرف الضوئي على الحروف",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
