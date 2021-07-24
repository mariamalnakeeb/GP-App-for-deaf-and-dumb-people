// @dart=2.9
import 'package:deaf_teacher/Dictionary.dart';
import 'package:deaf_teacher/SearchByImage.dart';
import 'package:deaf_teacher/ValidateWords.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deaf_teacher/AddWord.dart';
import 'package:deaf_teacher/SearchResult.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({
    Key key,
    this.isAdmin,
  }) : super(key: key);

  bool isAdmin;

  @override
  Widget build(BuildContext context) {
    List<Widget> val = [];
    Widget welcome = Column(
      children: val,
    );
    Widget value = Container();
    if (isAdmin) {
      value = GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ValidateWords.id);
        },
        child: Image(
          image: AssetImage("assets/Group 127.png"),
        ),
      );
      val.add(Center(
        child: Text(
          ' Application Admin ',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 22,
          ),
        ),
      ));
      val.add(SizedBox(
        height: 10,
      ));
    }
    return Container(
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              welcome,
              GestureDetector(
                onTap: () async {
                  print("tapped");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SearchDialog();
                    },
                  );
                },
                child: Image(
                  image: AssetImage("assets/Group 125.png"),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, SearchByImage.id),
                child: Image(
                  image: AssetImage("assets/Group 126.png"),
                ),
              ),
              value,
              GestureDetector(
                child: Image(
                  image: AssetImage("assets/Group 128.png"),
                ),
                onTap: () => Navigator.pushNamed(context, AddWord.id),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, Dictionary.id),
                child: Image(
                  image: AssetImage("assets/Group 129.png"),
                ),
              ),
            ]),
      )),
    );
  }
}

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key key}) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  @override
  Widget error = SizedBox.shrink();
  TextEditingController txtController = TextEditingController();

  Widget build(BuildContext context) {
    return AlertDialog(
      //shape:Border.all(width: ) ,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: new ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.red,
            ),
            child: TextField(
              onTap: () {
                setState(() {
                  error = SizedBox.shrink();
                });
              },
              controller: txtController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "أدخل كلمة",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          error,
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () async {
                String txt = txtController.text;
                if (txt.isEmpty) {
                  setState(() {
                    error = Center(
                        child: Text('تأكد من وضع قيمة في الحقل',
                            style: TextStyle(fontSize: 20, color: Colors.red)));
                  });
                } else {
                  print(txt);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchResult(word: txt)));
                }
                // checking part
                //   SearchResult result = SearchResult();
                // bool isfound =
                //   await result.getWordLink(txt);
              },
              child: Image(
                image: AssetImage('assets/Group 62.png'),
              ))
        ],
      ),
    );
  }
}
