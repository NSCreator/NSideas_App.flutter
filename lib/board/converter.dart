import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import '../project_files/projects_test.dart';

class BoardsConverter {
  String id;
  final HeadingConvertor heading;
  final String about, type;
  final List<FileUploader> images;
  final FileUploader pinDiagram, thumbnail;
  final List<DescriptionConvertor> descriptions;

  BoardsConverter({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.thumbnail,
    required this.about,
    required this.pinDiagram,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading.toJson(),
    'images': images.map((image) => image.toJson()).toList(), // Corrected this line
    'thumbnail': thumbnail.toJson(), // Corrected this line
    'type': type,
    'descriptions': descriptions.map((unit) => unit.toJson()).toList(),
    'about': about,
    'pinDiagram': pinDiagram.toJson(), // Corrected this line
  };

  static BoardsConverter fromJson(Map<String, dynamic> json) =>
      BoardsConverter(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        descriptions: DescriptionConvertor.fromMapList(
            json['descriptions'] ?? []),
        heading: HeadingConvertor.fromJson(json["heading"] ?? {}),
        thumbnail: FileUploader.fromJson(json["thumbnail"] ?? {}),
        images: (json["images"] as List<dynamic>?)
            ?.map((image) => FileUploader.fromJson(image))
            .toList() ??
            [],
        about: json["about"] ?? "",
        pinDiagram: FileUploader.fromJson(json["pinDiagram"] ?? {}),
      );

  static List<BoardsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
