import 'package:deaf_teacher/SearchResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:translator/translator.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'check.dart';
import 'Hello.dart';

class SearchByImageClasification extends StatefulWidget {
  const SearchByImageClasification({Key? key}) : super(key: key);
  static String id = "SearchByImageClasification";

  @override
  _SearchByImageClasificationState createState() =>
      _SearchByImageClasificationState();
}

class _SearchByImageClasificationState
    extends State<SearchByImageClasification> {
  List<Widget> childs = [];
  File? Picfile = null;
  bool _saving = false;
  final _auth = FirebaseAuth.instance;
  // String? transStr;
  // String? myword;
  var checker = check();
  void checkauth() async {
    bool val = await checker.doYouHaveRightPermission("AppAdmin");
    bool val2 = await checker.doYouHaveRightPermission("AppUser");
    if (!val && !val2) {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<String> translate(String word) async {
    String value;
    final translator = GoogleTranslator();

    var res = await translator.translate(word, from: 'en', to: 'ar');
    print(res.text);
    return res.text;
  }

  void restore() {
    setState(() {
      _saving = false;
    });
  }

  void setSaving() {
    setState(() {
      _saving = true;
      childs = [];
    });
  }

  Future<void> upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(
        "http://10.0.2.2:5000/"); // AVD uses 10.0.2.2 as an alias to your host on android emulator

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    print(imageFile.path);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print('response statuscode ${response.statusCode}');

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      print(value);
      final decoded = json.decode(value) as Map<String, dynamic>;
      print(decoded['wordFromPython']);

      String wo = decoded['wordFromPython'];
      String s = await translate(wo!);
      if (s != null && wo != null) {
        displayUploaded(wo, s);
        restore();
      }
    });
  }

  List<Widget> displayPick(File file) {
    List<Widget> mylist = [];
    if (Picfile != null) {
      print("file to display path ${file!.path}");
      mylist.add(Image.memory(
        Picfile!.readAsBytesSync(),
        height: 400,
        width: 600,
      ));
      mylist.add(SizedBox(height: 10));
      mylist.add(GestureDetector(
          child: FlatButton.icon(
        onPressed: () async {
          setSaving();
          await upload(Picfile!);
          //  print('myword is ' + myword!);
          //print('my translated word is ' + transStr!);
          restore();
          //restore();
        },
        label: Text('Search'),
        icon: Icon(Icons.cloud_upload),
      )));
      setState(() => childs = mylist);
    } else {
      print("video file is null in displaypick method");
    }
    restore();
    return mylist;
  }

  void removeOld() {
    setState(() {
      _saving = true;
      childs = [];
      Picfile = null;
    });
  }

  void displayUploaded(String myword, String transStr) {
    List<Widget> mylist = [
      SizedBox(
        height: 150,
      ),
      Center(
        child: Text(
          "$myword",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      SizedBox(
        height: 5,
      ),
      Center(
        child: Text(
          "$transStr",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    ];
    setState(() {
      childs = mylist;
    });

    Timer(Duration(seconds: 5), () {
      // 5 seconds over, navigate to Page2.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchResult(word: transStr!)));
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    print("method pick called");
    final p = await ImagePicker().getImage(source: source);
    if (p != null) {
      setState(() {
        removeOld();
        Picfile = File(p.path);
        displayPick(Picfile!);
      });
      print("picked file ..");
      print("picked file path ${Picfile!.path}");
    } else {
      print("picked file not working");
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    print("camera");
                    _pickImage(ImageSource.camera);
                  });
                },
                icon: Icon(Icons.photo_camera)),
            IconButton(
                onPressed: () {
                  setState(() {
                    print("gallery");
                    _pickImage(ImageSource.gallery);
                  });
                },
                icon: Icon(Icons.photo_library)),
          ],
        ),
      ),
      body: ModalProgressHUD(
        child: ListView(
          children: childs == [] ? displayPick(Picfile!) : childs,
        ),
        inAsyncCall: _saving,
        color: Colors.black12,
      ),
    );
  }
}
