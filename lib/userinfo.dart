import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class User_info extends StatefulWidget {
  User_info({
    Key? key,
    this.name,
    this.email,
    this.onPressed,
    this.txt,
  }) : super(key: key);
  String? name;
  String? email;
  String? txt;
  Function()? onPressed;
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
          Text(
            'name: ${widget.name}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          Text(
            'Email: ${widget.email}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
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
