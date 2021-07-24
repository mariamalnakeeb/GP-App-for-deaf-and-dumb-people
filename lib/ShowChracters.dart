import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowCharacters {
  String? word;
  Map<String, Image> maps = {};
  ShowCharacters({@required this.word}) {
    String alpha = "ابتثجحخدذرزسشصضطظعغفقكلمنهوي";
// create map
    for (int i = 0; i < alpha.length; i++) {
      if (alpha[i] == 'ا') {
        maps['ا'] = Image.asset('letters/$i.png');
        maps['إ'] = Image.asset('letters/$i.png');
        maps['أ'] = Image.asset('letters/$i.png');
        maps['آ'] = Image.asset('letters/$i.png');
        maps['ء'] = Image.asset('letters/$i.png');
        maps['ى'] = Image.asset('letters/$i.png');
        maps['ئ'] = Image.asset('letters/$i.png');
        maps['ؤ'] = Image.asset('letters/$i.png');
      } else if (alpha[i] == 'ت') {
        maps['ت'] = Image.asset('letters/$i.png');
        maps['ة'] = Image.asset('letters/$i.png');
      } else {
        maps[alpha[i]] = Image.asset('letters/$i.png');
      }
    }
  }

  Widget convert() {
    var mylist = word!.split(' ');
    List<Widget> myresult = [];
    for (int i = 0; i < mylist.length; i++) {
      myresult.add(_ConvertWordToSymbols(mylist[i]));
    }
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xff082b5a5),
      ),
      child: Column(
        children: myresult,
      ),
    );
  }

  Widget _ConvertWordToSymbols(String string) {
    List<Widget> mylist = [];
    for (int i = string.length - 1; i >= 0; i--) {
      mylist.add(maps[string[i]]!);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mylist,
    );
  }
}
