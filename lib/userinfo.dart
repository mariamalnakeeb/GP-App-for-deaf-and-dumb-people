import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class User_info extends StatefulWidget {
  User_info(
      {Key? key,
      this.name,
      this.email,
      this.onPressed,
      this.txt,
      this.numOfaccepted,
      this.numOfrejected})
      : super(key: key);
  String? name;
  String? email;
  String? txt;
  Function()? onPressed;
  String? numOfaccepted;
  String? numOfrejected;
  @override
  _User_infoState createState() => _User_infoState();
}

class _User_infoState extends State<User_info> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                ' \u{2705} ${widget.numOfaccepted}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.email}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
              Text(
                ' \u{274E} ${widget.numOfrejected}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: RaisedButton(
              onPressed: widget.onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.only(left: 0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: Color(0xFFA4C9BE),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 150.0, minHeight: 33.0),
                  alignment: Alignment.center,
                  child: Text(
                    widget.txt!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class User_info2 extends StatefulWidget {
  User_info2({
    Key? key,
    this.name,
    this.email,
    this.onAccept,
    this.onReject,
    this.numOfaccepted,
    this.numOfrejected,
    this.txt,
  }) : super(key: key);
  String? name;
  String? email;
  String? txt;
  String? numOfaccepted;
  String? numOfrejected;
  Function()? onAccept;
  Function()? onReject;
  @override
  _User_info2State createState() => _User_info2State();
}

class _User_info2State extends State<User_info2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                ' \u{2705} ${widget.numOfaccepted}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.email}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
              Text(
                ' \u{274E} ${widget.numOfrejected}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: widget.onReject,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.only(left: 0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xFFA4C9BE),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minHeight: 33.0),
                    alignment: Alignment.center,
                    child: Text(
                      'reject',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: widget.onAccept,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.only(left: 0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xFFA4C9BE),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minHeight: 33.0),
                    alignment: Alignment.center,
                    child: Text(
                      'accept',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
