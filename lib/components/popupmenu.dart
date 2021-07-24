import 'package:deaf_teacher/Hello.dart';
import 'package:deaf_teacher/userProfile.dart';
import 'package:deaf_teacher/Notifications.dart';
import 'package:deaf_teacher/Hello.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deaf_teacher/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PopupMenuReusable extends StatelessWidget {
  PopupMenuReusable();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: Row(
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, userProfile.id);
                      print("ملف شخصي");
                    },
                    child: Text(
                      'الملف الشخصى',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
              PopupMenuItem(
                  child: Row(
                children: [
                  Icon(
                    Icons.circle_notifications,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('الاشعارات');
                      Navigator.pushNamed(context, Notifications.id);
                    },
                    child: Text(
                      'اشعارات',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
              PopupMenuItem(
                  child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () async {
                        print("signout");
                        await signOut();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('تسجيل خروج')),
                ],
              )),
            ]);
  }
}

class ReusableNotificationWidget extends StatelessWidget {
  ReusableNotificationWidget({this.content, this.number});
  final String? content;
  final int? number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0xff82b5a5), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Notification #' + number.toString(),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          content!,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ]),
    );
  }
}
