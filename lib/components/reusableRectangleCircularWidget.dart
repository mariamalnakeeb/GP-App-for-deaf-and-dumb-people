import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableCircularWidget extends StatelessWidget {
  ReusableCircularWidget(
      {@required this.widgetWidth,
      @required this.color,
      @required this.number,
      @required this.widgetTxt});
  final String? widgetTxt;
  final Color? color;
  final int? number;
  final double? widgetWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: widgetWidth,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            widgetTxt!,
            style: TextStyle(color: Colors.white, fontSize: 17),
          )
        ],
      ),
    );
  }
}

class ReusableNotificationWidget extends StatelessWidget {
  ReusableNotificationWidget({@required this.content, @required this.number});
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
