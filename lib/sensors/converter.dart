import 'package:cloud_firestore/cloud_firestore.dart';

import '../project_files/projects_test.dart';
import '../textFeild.dart';

class SensorsConverter {
  final String id,type;
  final HeadingConvertor heading;
  final String about;
  final List<TableConvertor> technicalParameters, pinConnections;
  final List<String> images, pinDiagrams;
  final List<DescriptionConvertor> descriptions;

  SensorsConverter({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.about,
    required this.pinDiagrams,
    required this.technicalParameters,
    required this.pinConnections,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading.toJson(),
    'images': images,
    'type': type,
    'descriptions': descriptions.map((desc) => desc.toJson()).toList(),
    'about': about,
    'pinDiagrams': pinDiagrams,
    'technicalParameters':
    technicalParameters.map((table) => table.toJson()).toList(),
    'pinConnections':
    pinConnections.map((table) => table.toJson()).toList(),
  };

  static SensorsConverter fromJson(Map<String, dynamic> json) => SensorsConverter(
    id: json['id'] ?? "",
    descriptions: DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
    heading: HeadingConvertor.fromJson(json["heading"]),
    images: List<String>.from(json["images"]),
    about: json["about"],
    type: json["type"],
    pinDiagrams: List<String>.from(json["pinDiagrams"]),
    technicalParameters: TableConvertor.fromMapList(json['technicalParameters'] ?? []),
    pinConnections: TableConvertor.fromMapList(json['pinConnections'] ?? []),
  );

  static List<SensorsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}


Stream<List<SensorsConverter>> readsensors() => FirebaseFirestore.instance
    .collection('sensors')
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => SensorsConverter.fromJson(doc.data()))
    .toList());
