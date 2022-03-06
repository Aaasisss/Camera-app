import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Classes.dart';

class SelectFile extends StatefulWidget {
  const SelectFile({Key? key}) : super(key: key);

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  UploadTask? task;
  File? file;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      print("added to the github");
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return null;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download link: ${urlDownload}");
  }

  @override
  Widget build(BuildContext context) {
    final fileName = (file != null ? basename(file!.path) : 'No File Selected');
    print("File path:   ${file}");
    print("File Name: ${fileName}");

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: Size.fromHeight(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 28,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Select File",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: selectFile,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              fileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 48,
            ),
            ButtonTheme(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: Size.fromHeight(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload,
                      size: 28,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Upload File",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: uploadFile,
              ),
            ),
            SizedBox(height: 20),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        ),
      ),
    );
  }
}
