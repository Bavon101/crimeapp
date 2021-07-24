import 'package:crimeapp/Models/CrimesModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FireData {
  final FirebaseApp app;
  FireData({required this.app});
  init() {
    this.db = FirebaseDatabase(app: app).reference();
    this._crimeRef = FirebaseDatabase.instance.reference().child('crimes');
  }

  DatabaseReference? db;
  late DatabaseReference _crimeRef;
  Future<DataSnapshot> getCrimes() async {
    return this._crimeRef.once();
  }

 Future<void> uploadData({required CrimesModel crime}) {
   return crime.key == '' ? this
        ._crimeRef
        .push()
        .set(crime.toJson()): this._crimeRef.child(crime.key!).set(crime.toJson());
  }
}
