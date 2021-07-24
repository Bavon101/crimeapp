// To parse this JSON data, do
//
//     final crimesModel = crimesModelFromJson(jsonString);

import 'dart:convert';

CrimesModel crimesModelFromJson(String str) =>
    CrimesModel.fromJson(json.decode(str));

String crimesModelToJson(CrimesModel data) => json.encode(data.toJson());

class CrimesModel {
  CrimesModel(
      {this.reports,
      this.images,
      this.lon,
      this.place,
      this.lat,
      this.crimeId,
      this.key = ''
      });

  int? reports;
  List<String>? images;
  double? lon;
  String? place;
  double? lat;
  String? crimeId;
  String? key;

  factory CrimesModel.fromJson(Map<dynamic, dynamic> json) => CrimesModel(
      reports: json["reports"],
      images: List<String>.from(json["images"].map((x) => x)),
      lon: json["lon"].toDouble(),
      place: json["place"],
      lat: json["lat"].toDouble(),
      crimeId: json["id"],
      key: json["key"]
      );

  Map<String, dynamic> toJson() => {
        "reports": reports,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "lon": lon,
        "place": place,
        "lat": lat,
        "id": crimeId,
        "key":key
      };
}
