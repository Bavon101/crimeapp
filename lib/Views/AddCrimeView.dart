import 'dart:developer';
import 'dart:io';

import 'package:crimeapp/Contollers/AppState.dart';
import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:crimeapp/Contollers/const.dart';
import 'package:crimeapp/Models/CrimesModel.dart';
import 'package:crimeapp/Models/placeModel.dart';
import 'package:crimeapp/Widgets/ImageCard.dart';
import 'package:crimeapp/Widgets/PlaceCard.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';

final ImagePicker _picker = ImagePicker();

class AddCrimeView extends StatefulWidget {
  const AddCrimeView({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _AddCrimeViewState createState() => _AddCrimeViewState();
}

class _AddCrimeViewState extends State<AddCrimeView> {
  List<XFile>? images = [];
  List<Place> listPlace = [];

  getImages() async {
    await _picker.pickMultiImage().then((value) {
      if (mounted) {
        setState(() {
          images = value;
        });
      }
    });
  }

  getPlaces(String query) async {
    String url2 =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$APIKEYGOOGLE&input=${Uri.encodeQueryComponent(query)}";
    Response response = await Dio().get(url2);
    setState(() {
      listPlace = Place.parseLocationList(response.data);
    });
  }

  decodeLocation(String id) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$APIKEYGOOGLE&placeid=" +
            Uri.encodeQueryComponent(id);

    Response? response = await Dio().get(url).then((Response results) async {
      Map<String, dynamic> placeLatLng =
          results.data['result']['geometry']['location'];
      setState(() {
        latitude = double.parse(placeLatLng['lat'].toString());
        longitude = double.parse(placeLatLng['lng'].toString());
      });
    });
  }

  double? longitude;
  double? latitude;
  bool sendingData = false;
  _updateSendingActivity() {
    setState(() {
      sendingData = !sendingData;
    });
  }

  TextEditingController placeController = new TextEditingController();
  _uploadImageFiles() async {
    await uploadFiles(filesFromXfile(images: images)).then((value) {});
  }

  List<String> imagesUrls = [];
  uploadFiles(List<File> _images) async {
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
      setState(() {});
    }).then((value) => {imagesUrls, addCrime()});
  }

  String pureId(String d) =>
      d.replaceAll('-', '').replaceAll('.', '').replaceAll('+', '');
 int reports = 1;
  String key = '';
  addCrime() {
   
    if (existingCrime != null) {
      setState(() {
        reports = existingCrime!.reports! + 1;
        imagesUrls.addAll(existingCrime!.images!);
        key = existingCrime!.key!;
      });
    }
    CrimesModel _crimeToReport = new CrimesModel(
        images: imagesUrls,
        crimeId: crimeId(),
        lat: latitude,
        lon: longitude,
        reports: reports,
        key: key,
        place: placeController.text.trim());
    fireData
        .uploadData(crime: _crimeToReport)
        .then((value) => _onDone())
        .onError((error, stackTrace) => {
              showToast(message: 'Something broke try again later'),
              _updateSendingActivity()
            });
  }

  _onDone() {
    _updateSendingActivity();
    showToast(message: 'Crime data was added');
    goback(context: context);
  }

  String crimeId() =>
      pureId(latitude.toString()) + pureId(longitude.toString());
  CrimesModel? existingCrime;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Report a Crime'),
        ),
        body: Center(
          child: SingleChildScrollView(
              physics: physics,
              child: Container(
                height: HEIGHT(context: context),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: HEIGHT(context: context) * .05,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Provide Crime details to proceed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: placeController,
                          onChanged: (q) => getPlaces(q),
                          decoration: InputDecoration(
                              labelText: 'Crime Location',
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      placeController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.close))),
                        ),
                      ),
                      Column(
                        children: List.generate(
                            listPlace.length,
                            (index) => PlaceCard(
                                onTap: (id) {
                                  // get location co-ordinates
                                  decodeLocation(id);
                                  setState(() {
                                    placeController.text =
                                        listPlace[index].name!;
                                    listPlace.clear();
                                  });
                                },
                                place: listPlace[index])),
                      ),
                      TextButton.icon(
                          onPressed: () => getImages(),
                          icon: Icon(Icons.add_a_photo_rounded),
                          label: Text('Include images')),
                      // display chosen images

                      if (images != null)
                        Container(
                          height: images!.length > 0
                              ? HEIGHT(context: context) * .30
                              : 0,
                          child: Center(
                            child: ListView.builder(
                                physics: physics,
                                scrollDirection: Axis.horizontal,
                                itemCount: images!.length,
                                itemBuilder: (context, index) {
                                  File file = File(images![index].path);
                                  return ImageCard(
                                    file: file,
                                  );
                                }),
                          ),
                        ),
                      Align(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                            onPressed: !sendingData
                                ? () {
                                    // check if location has been selected
                                    if (latitude != null) {
                                      setState(() {
                                        existingCrime = appState
                                            .existingCrimeMode(id: crimeId());
                                      });
                                      _updateSendingActivity();
                                      _uploadImageFiles();
                                    } else {
                                      showToast(
                                          message:
                                              'Please provide the crime location');
                                    }
                                  }
                                : null,
                            icon: Icon(Icons.send_rounded),
                            label: !sendingData
                                ? Text('Send report')
                                : CircularProgressIndicator()),
                      ))
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}
