import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

// void alert(context) {
//   print("tapped");
//   setState() {
//     showDialog(
//       context: context, builder: (context) { return AlertDialog(
//         content: TextField(
//           decoration: InputDecoration(
//             hintText: "أEnter word",
//           ),
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.grey,
//           ),
//         ),
//       )},
//     );
//   }
// }

//Function myFunc = alert;
// List<Widget> getWidgets() {
//   List<int> num = [125, 126, 127, 128, 129];
//   List<Widget> myList = [];
//   for (int i = 0; i < num.length; i++) {
//     myList.add(new Container(
//         child: GestureDetector(
//       onTap: i == 0 ? myFunc : () {},
//       child: Image(
//         image: AssetImage("assets/Group ${num[i]}.png"),
//       ),
//     )));
//     //  print(num[i]);
//   }
//
//   return myList;
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtController = TextEditingController();
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
      body: Container(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    print("tapped");
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
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
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    String txt = txtController.text;
                                    print(txt);
                                  },
                                  child: Image(
                                    image: AssetImage('assets/Group 62.png'),
                                  ))
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image(
                    image: AssetImage("assets/Group 125.png"),
                  ),
                ),
                GestureDetector(
                  child: Image(
                    image: AssetImage("assets/Group 126.png"),
                  ),
                ),
                GestureDetector(
                  child: Image(
                    image: AssetImage("assets/Group 127.png"),
                  ),
                ),
                GestureDetector(
                  child: Image(
                    image: AssetImage("assets/Group 128.png"),
                  ),
                ),
                GestureDetector(
                  child: Image(
                    image: AssetImage("assets/Group 129.png"),
                  ),
                ),
              ]),
        )),
      ),
    );
  }
}
