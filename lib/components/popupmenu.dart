import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupMenuReusable extends StatelessWidget {
  PopupMenuReusable();

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
                  Text(
                    'الملف الشخصى',
                    textAlign: TextAlign.center,
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
                  Text(
                    'اشعارات',
                    textAlign: TextAlign.center,
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
                  Text('تسجيل خروج'),
                ],
              )),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fitWidth,
                      width: 50,
                      alignment: Alignment.center,
                    )
                  ],
                ),
              )
            ]);
    throw UnimplementedError();
  }
}

class ReusableNotificationWidget extends StatelessWidget {
  ReusableNotificationWidget({@required this.content, @required this.number});
  final String content;
  final int number;

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
          content,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ]),
    );
    throw UnimplementedError();
  }
}
