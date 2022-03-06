import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'SelectFile.dart';

class HomePage extends StatefulWidget {
  //File? file;
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var _imageFromCamera;
  late XFile? _imageFromGallery;
  late XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  initState() {
    setState(() {
      _imageFromCamera = null;
      _imageFromGallery = null;
      _image = null;
    });
  }

  Future openCamera() async {
    var imageFromCamera = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFromCamera = imageFromCamera;
      _image = _imageFromCamera;
      //widget.file = File(imageFromCamera!.path);
    });
    Navigator.of(context).pop();
  }

  Future openGallery() async {
    var imageFromGallery = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFromGallery = imageFromGallery;
      _image = _imageFromGallery;
      //widget.file = File(imageFromGallery!.path);
      print("the file path is << ${File(_image!.path)} >>");
    });
  }

  Future<void> _optionsDialogueBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text(
                    "Take a Picture",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onTap: openCamera,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: Text(
                    "Select Image From gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onTap: openGallery,
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera App"),
      ),
      body: SelectFile(),
      floatingActionButton: FloatingActionButton(
        onPressed: _optionsDialogueBox,
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add_a_photo),
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add_a_photo),
            )
          ],
        ),
        tooltip: "Open Camera",
      ),
    );
  }
}
