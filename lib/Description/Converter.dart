import 'package:nsideas/textFeild.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

class DescriptionConvertor {
  final String heading;
  final List<TableConvertor> table;
  final List<String> points;
  final List<FileUploader> ivf;
  final List<CodeFilesConvertor> code;

  DescriptionConvertor({
    required this.heading,
    required this.points,
    required this.ivf,
    required this.code,
    required this.table,
  });

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "points": points.toList(),
    'ivf': ivf.map((image) => image.toJson()).toList(), // Fix here
    'files': code.map((file) => file.toJson()).toList(),
    'table': table.map((table) => table.toJson()).toList(),
  };

  static DescriptionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionConvertor(
        heading: json["heading"],
        points: List<String>.from(json["points"]),
        ivf: (json['ivf'] as List<dynamic>? ?? [])
            .map((item) => FileUploader.fromJson(item))
            .toList(),
        code: (json['files'] as List<dynamic>? ?? [])
            .map((item) => CodeFilesConvertor.fromJson(item))
            .toList(),
        table: TableConvertor.fromMapList(json['table'] ?? []),
      );

  static List<DescriptionConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ConvertorForTRCSRC {
  final String heading;
  final Path path;
  final FileUploader ivf;

  ConvertorForTRCSRC({
    required this.heading,
    required this.path,
    required this.ivf,
  });

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "path": path.toJson(),
    'ivf': ivf.toJson(), // Convert IVFUploader to JSON
  };

  static ConvertorForTRCSRC fromJson(Map<String, dynamic> json) =>
      ConvertorForTRCSRC(
        heading: json["heading"] ?? "",
        ivf: FileUploader.fromJson(json["ivf"] ?? {}),
        path: Path.fromJson(json["path"] ?? {}),
      );

  static List<ConvertorForTRCSRC> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class Path {
  final String id, path;

  Path({
    required this.id,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "path": path,
  };

  static Path fromJson(Map<String, dynamic> json) => Path(
    id: json["id"] ?? "",
    path: json["path"] ?? "",
  );

  static List<Path> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
