import 'dart:async';
import 'dart:developer';

import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:crimeapp/Models/CrimesModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';

class AppState extends ChangeNotifier {
  Completer<GoogleMapController> controller = Completer();
  double lat = 0, lon = 0;

  CameraPosition currentLocationView() => CameraPosition(
        target: LatLng(this.lat, this.lon),
        zoom: 12,
      );
// create market colors
  double greenMarker = BitmapDescriptor.hueGreen;
  double redMarker = BitmapDescriptor.hueRed;
  double orangeMarker = BitmapDescriptor.hueOrange;

// crime listener
  StreamSubscription<Event>? _crimesSubscription;

  // function to get Markets set
  Set<Marker> crimeMarkers() {
    Set<Marker> ms = {};
    crimes.forEach((crime) {
      ms.add(_getmarkers(crime: crime));
    });
    return ms;
  }

  CrimesModel? selectedCrime;
  // a function to get tapped ride or untap
  updateSelectedCrime({CrimesModel? crime}) {
    selectedCrime = crime;
    notifyListeners();
  }

  startListeningToCrimes() {
    _crimesSubscription = fireData.db!.onValue.listen((Event event) {
      // if there is a change get data
      getCrimes();
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      showToast(message: 'An error occurred');
    });
  }

  // get dynamic marker
  Marker _getmarkers({required CrimesModel crime}) => Marker(
      markerId: MarkerId(crime.crimeId!),
      icon: BitmapDescriptor.defaultMarkerWithHue(crime.reports! <= 5
          ? greenMarker
          : crime.reports! > 5 && crime.reports! < 20
              ? orangeMarker
              : redMarker),
      position: LatLng(crime.lat!, crime.lon!),
      onTap: () => updateSelectedCrime(crime: crime));
  getUserCurrentLocation() {
    _determinePosition().then((position) => !errorOnLocationAccess
        ? {
            this.lat = position.latitude,
            this.lon = position.longitude,
            notifyListeners()
          }
        : {
            // handle denied permission
          });
  }

  bool mapLocationLoaded() => this.lat != 0 && this.lon != 0;
  bool errorOnLocationAccess = false;
  updateErrorOnLocationAccess({bool status = false}) {
    errorOnLocationAccess = status;
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    updateErrorOnLocationAccess();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      updateErrorOnLocationAccess(status: true);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        updateErrorOnLocationAccess(status: true);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      updateErrorOnLocationAccess(status: true);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  //! firebase logic
  DatabaseReference _crimePref =
      FirebaseDatabase.instance.reference().child('crimes');
  
 

  CrimesModel? existingCrimeMode({required String id}) {
    try{
      return 
      crimes.firstWhere((element) => element.crimeId == id);
    }catch(e){}
    return null;
  }
// function for getting crimes
  List<CrimesModel> crimes = [];
  getCrimes() {
    crimes.clear();
    fireData.getCrimes().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;

        values.forEach((key, values) {
          // create crime models
          Map<dynamic, dynamic> value = Map<dynamic, dynamic>.from(values);
          CrimesModel crime = CrimesModel.fromJson(value);
          crime.key = key;
          crimes.add(crime);
          notifyListeners();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
   
    _crimesSubscription!.cancel();
  }
}
