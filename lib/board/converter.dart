import '../project_files/projects_test.dart';

class BoardsConverter {
  String id;
  final HeadingConvertor heading;
  final String about, type;
  final List<String> images, pinDiagrams;
  final List<DescriptionConvertor> descriptions;

  BoardsConverter({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.about,
    required this.pinDiagrams,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading.toJson(),
    'images': images,
    'type': type,
    "descriptions": descriptions.map((unit) => unit.toJson()).toList(),
    'about': about,
    'circuit_diagrams': pinDiagrams,
  };

  static BoardsConverter fromJson(Map<String, dynamic> json) => BoardsConverter(
    id: json['id'],
    type: json['type'],
    descriptions:
    DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
    heading: HeadingConvertor.fromJson(json["heading"]),
    images: List<String>.from(json["images"]),
    about: json["about"],
    pinDiagrams: List<String>.from(json["circuit_diagrams"]??[]),
  );

  static List<BoardsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
