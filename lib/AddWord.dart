import 'package:deaf_teacher/uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class AddWord extends StatefulWidget {
  static String id = "AddWord";
  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  @override
  File? Videofile;
  File? GifFile;
  bool _saving = false;
  List<Widget> childs = [];
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription? _subscription;
  double _progressState = 0;
  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _progressState = progress;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) _subscription!.unsubscribe();
    // _loadingStreamCtrl.close();
  }

  void removeOld() {
    setState(() {
      _saving = true;
      childs = [];
      Videofile = null;
      GifFile = null;
      WordController.text = "";
    });
  }

  void restore() {
    setState(() {
      _saving = false;
    });
  }

  TextEditingController WordController = TextEditingController();
  Future<void> _pickVideo(ImageSource source) async {
    print("method pick called");
    final p = await ImagePicker().getVideo(source: source);
    if (p != null) {
      setState(() {
        removeOld();
        Videofile = File(p.path);
        _Convert2Gif(Videofile!);
        displayPick(GifFile!);
      });
      print("picked file ..");
      print("picked file path ${Videofile!.path}");
    } else {
      print("picked file not working");
    }
  }

  Future<void> _Convert2Gif(File file) async {
    if (file == null) print("convert method file argument is null");
    VideoPlayerController controller = VideoPlayerController.file(file);
    await controller.initialize();
    int sec = controller.value.duration.inSeconds;
    final gif = await _flutterVideoCompress.convertVideoToGif(file.path,
        duration: (sec));
    print("duration $sec");
    if (gif != null) {
      setState(() {
        GifFile = gif;
      });
      debugPrint(gif.path);
      print("converted");
      print(gif.path);
      displayPick(gif!);
    } else {
      print("gif equal null");
    }
  }

  void displayUploaded() {
    List<Widget> mylist = [
      SizedBox(
        height: 150,
      ),
      Center(
        child: Text(
          "Video uploaded successfully ",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Center(
        child: Text(
          " but need review by admins ",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Center(
        child: Text(
          "thank you",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    ];
    setState(() {
      childs = mylist;
    });
  }

  List<Widget> displayPick(File file) {
    List<Widget> mylist = [];
    if (file != null) {
      print("file to display path ${file!.path}");
      mylist.add(Image.memory(
        file!.readAsBytesSync(),
        height: 400,
        width: 600,
      ));
      mylist.add(SizedBox(height: 10));
      mylist.add(Padding(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: TextField(
          controller: WordController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: "أدخل كلمة",
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ));
      mylist.add(GestureDetector(
          child: FlatButton.icon(
        onPressed: () async {
          print(WordController.text);
          if (!WordController.text.isEmpty && GifFile != null) {
            uploader tmp =
                new uploader(file: GifFile, word: WordController.text);
            removeOld();
            await tmp.upload();
            displayUploaded();
            restore();
          }
        },
        label: Text('upload'),
        icon: Icon(Icons.cloud_upload),
      )));
      setState(() => childs = mylist);
    } else {
      print("video file is null in displaypick method");
    }
    restore();
    return mylist;
  }

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
                    _pickVideo(ImageSource.camera);
                    //    if (Videofile != null) _Convert2Gif(Videofile!);
                  });
                },
                icon: Icon(Icons.photo_camera)),
            IconButton(
                onPressed: () {
                  setState(() {
                    print("gallery");
                    _pickVideo(ImageSource.gallery);
                  });
                },
                icon: Icon(Icons.photo_library)),
          ],
        ),
      ),
      body: ModalProgressHUD(
        child: ListView(
          children: childs == [] ? displayPick(GifFile!) : childs,
        ),
        inAsyncCall: _saving,
        color: Colors.black12,
      ),
    );
  }
}
