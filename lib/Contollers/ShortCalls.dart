import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

double WIDTH({required BuildContext context}) =>
    MediaQuery.of(context).size.width;
double HEIGHT({required BuildContext context}) =>
    MediaQuery.of(context).size.height;

void showToast(
    {required String message,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}

goback({required BuildContext context}) {
  Navigator.pop(context);
}

goto({required BuildContext context, required Widget child}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => child));
}

ScrollPhysics physics =
    const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
List<File> filesFromXfile({required List<XFile>? images}) {
  List<File> files = [];
  images!.forEach((image) {
    files.add(File(image.path));
  });
  return files;
}

Future<List<String>> _uploadFiles(List<File> _images) async {
  List<String> imagesUrls = [];
  //Future.wait(_images.map((e) {}));
  Future.forEach(_images, (File _image) async {
    List splits = _image.path.split('/');
    String imagePath = splits.last;
    UploadTask task = FirebaseStorage.instance
        .ref()
        .child('crimeposts/$imagePath')
        .putFile(_image);
    var t = await task;
    imagesUrls.add(await t.ref.getDownloadURL());
  }).then((value) => imagesUrls);

  return imagesUrls;
}
