import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import '../project_files/projects_test.dart';
import '../textFeild.dart';

class SensorsConverter {
  final String id, type;
  final HeadingConvertor heading;
  final String about;
  final List<TableConvertor> technicalParameters, pinConnections;
  final List<FileUploader> images;
  final FileUploader pinDiagram, thumbnail;
  final List<DescriptionConvertor> descriptions;

  SensorsConverter({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.about,
    required this.pinDiagram,
    required this.thumbnail,
    required this.technicalParameters,
    required this.pinConnections,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading.toJson(),
    'images': images.map((image) => image.toJson()).toList(),
    'type': type,
    'descriptions': descriptions.map((desc) => desc.toJson()).toList(),
    'about': about,
    'pinDiagram': pinDiagram.toJson(),
    'thumbnail': thumbnail.toJson(),
    'technicalParameters': technicalParameters.map((table) => table.toJson()).toList(),
    'pinConnections': pinConnections.map((table) => table.toJson()).toList(),
  };

  static SensorsConverter fromJson(Map<String, dynamic> json) => SensorsConverter(
    id: json['id'] ?? "",
    heading: HeadingConvertor.fromJson(json["heading"] ?? {}),
    type: json["type"] ?? "",
    images: (json["images"] as List<dynamic>?)
        ?.map((image) => FileUploader.fromJson(image))
        .toList() ??
        [],
    descriptions: DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
    about: json["about"] ?? "",
    pinDiagram: FileUploader.fromJson(json["pinDiagram"] ?? {}),
    thumbnail: FileUploader.fromJson(json["thumbnail"] ?? {}),
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
