import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/sensors/converter.dart';
import 'package:nsideas/textFeild.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../board/converter.dart';
import '../uploader/telegram_uploader.dart';

Future<List<ProjectConverter>> getProjects(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final studyMaterialsJson = prefs.getString("projects") ?? "";

    if (studyMaterialsJson.isEmpty || isLoading) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('projects').get();
      List<Map<String, dynamic>> projectsData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      String projectsJson = jsonEncode(projectsData);
      await prefs.setString("projects", projectsJson);
      List<ProjectConverter> projects =
          projectsData.map((json) => ProjectConverter.fromJson(json)).toList();
      return projects;
    } else {
      List<Map<String, dynamic>> projectsJsonList =
          List<Map<String, dynamic>>.from(json.decode(studyMaterialsJson));
      List<ProjectConverter> projects = projectsJsonList
          .map((json) => ProjectConverter.fromJson(json))
          .toList();

      return projects;
    }
  } catch (e) {
    // Handle exceptions
    print("Error in getProjects: $e");
    return []; // Return empty list or handle error accordingly
  }
}

Future<List<SensorsConverter>> getSensors(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final sensorsJson = prefs.getString("sensors") ?? "";

    if (sensorsJson.isEmpty || isLoading) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('sensors').get();
      List<Map<String, dynamic>> sensorsData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      String sensorsJson = jsonEncode(sensorsData);
      await prefs.setString("sensors", sensorsJson);
      List<SensorsConverter> sensors =
          sensorsData.map((json) => SensorsConverter.fromJson(json)).toList();
      return sensors;
    } else {
      List<Map<String, dynamic>> sensorsJsonList =
          List<Map<String, dynamic>>.from(json.decode(sensorsJson));
      List<SensorsConverter> sensors = sensorsJsonList
          .map((json) => SensorsConverter.fromJson(json))
          .toList();

      return sensors;
    }
  } catch (e) {
    // Handle exceptions
    print("Error in getSensors: $e");
    return []; // Return empty list or handle error accordingly
  }
}

Future<List<BoardsConverter>> getBoards(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final boardsJson = prefs.getString("boards") ?? "";

    if (boardsJson.isEmpty || isLoading) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('boards').get();
      List<Map<String, dynamic>> boardsData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      String boardsJson = jsonEncode(boardsData);
      await prefs.setString("boards", boardsJson);
      List<BoardsConverter> boards =
          boardsData.map((json) => BoardsConverter.fromJson(json)).toList();
      return boards;
    } else {
      List<Map<String, dynamic>> boardsJsonList =
          List<Map<String, dynamic>>.from(json.decode(boardsJson));
      List<BoardsConverter> boards =
          boardsJsonList.map((json) => BoardsConverter.fromJson(json)).toList();

      return boards;
    }
  } catch (e) {
    // Handle exceptions
    print("Error in getBoards: $e");
    return []; // Return empty list or handle error accordingly
  }
}

Future<void> createProject({
  required String id,
  required String type,
  required String youtubeUrl,
  required IVFUploader thumbnail,
  required bool isUpdate,
  required bool isFree,
  required bool isContainsAds,
  required HeadingConvertor heading,
  required String about,
  required List<String> tags,
  required List<String> displayHere,
  required List<String> tableOfContent,
  required List<ConvertorForTRCSRC> componentsAndSupplies,
  required List<ConvertorForTRCSRC> appAndPlatforms,
  required List<ConvertorForTRCSRC> toolsRequired,
  required List<DescriptionConvertor> description,
  required List<IVFUploader> images,
}) async {
  final docTrip = FirebaseFirestore.instance.collection('projects').doc(id);

  final tripData = ProjectConverter(
    id: id,
    type: type,
    youtubeUrl: youtubeUrl,
    thumbnail: thumbnail,
    isFree: isFree,
    isContainsAds: isContainsAds,
    heading: heading,
    about: about,
    tags: tags,
    displayHere: displayHere,
    tableOfContent: tableOfContent,
    componentsAndSupplies: componentsAndSupplies,
    appAndPlatforms: appAndPlatforms,
    toolsRequired: toolsRequired,
    description: description,
    images: images,
  );

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
}

class ProjectConverter {
  final List<String> displayHere;
  final bool isFree, isContainsAds;
  final String id, type, about, youtubeUrl;
  final IVFUploader thumbnail;
  final HeadingConvertor heading;
  final List<String> tableOfContent;
  final List<IVFUploader> images;
  final List<String> tags;
  final List<DescriptionConvertor> description;
  final List<ConvertorForTRCSRC> componentsAndSupplies,
      toolsRequired,
      appAndPlatforms;

  ProjectConverter({
    required this.id,
    required this.type,
    required this.displayHere,
    required this.thumbnail,
    required this.tags,
    required this.heading,
    required this.isFree,
    required this.isContainsAds,
    required this.tableOfContent,
    required this.appAndPlatforms,
    required this.youtubeUrl,
    required this.componentsAndSupplies,
    required this.description,
    required this.about,
    required this.toolsRequired,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "about": about,
    "type": type,
    "tags": tags,
    "tableOfContent": tableOfContent,
    "displayHere": displayHere,
    "thumbnail": thumbnail.toJson(), // Assuming IVFUploader has a toJson method
    "isContainsAds": isContainsAds,
    "isFree": isFree,
    "youtubeLink": youtubeUrl,
    "heading": heading.toJson(),
    "descriptions": description.map((unit) => unit.toJson()).toList(),
    "componentsAndSupplies":
    componentsAndSupplies.map((oldPaper) => oldPaper.toJson()).toList(),
    "toolsRequired":
    toolsRequired.map((textBook) => textBook.toJson()).toList(),
    "appAndPlatforms":
    appAndPlatforms.map((textBook) => textBook.toJson()).toList(),
    "images":
    images.map((imageUploader) => imageUploader.toJson()).toList(),
  };

  static ProjectConverter fromJson(Map<String, dynamic> json) =>
      ProjectConverter(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        about: json['about'] ?? "",
        youtubeUrl: json['youtubeLink'] ?? "",
        thumbnail: IVFUploader.fromJson(json['thumbnail'] ?? {}),
        heading: HeadingConvertor.fromJson(json['heading'] ?? {}),
        isFree: json['isFree'] ?? false,
        isContainsAds: json['isContainsAds'] ?? false,
        tags: List<String>.from(json['tags'] ?? []),
        displayHere: List<String>.from(json['displayHere'] ?? []),
        tableOfContent: List<String>.from(json['tableOfContent'] ?? []),
        componentsAndSupplies: ConvertorForTRCSRC.fromMapList(json['componentsAndSupplies'] ?? []),
        appAndPlatforms: ConvertorForTRCSRC.fromMapList(json['appAndPlatforms'] ?? []),
        toolsRequired: ConvertorForTRCSRC.fromMapList(json['toolsRequired'] ?? []),
        description: DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
        images: IVFUploader.fromMapList(json['images'] ?? []),
      );

  static List<ProjectConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class HeadingConvertor {
  final String short;
  final String full;

  HeadingConvertor({
    required this.full,
    required this.short,
  });

  Map<String, dynamic> toJson() => {"full": full, "short": short};

  static HeadingConvertor fromJson(Map<String, dynamic> json) =>
      HeadingConvertor(
        short: json['short'] ?? "",
        full: json["full"] ?? "",
      );

  static List<HeadingConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class DescriptionConvertor {
  final String heading;
  final List<TableConvertor> table;
  final List<String> points;
  final List<IVFUploader> IVF;
  final List<CodeFilesConvertor> files;

  DescriptionConvertor({
    required this.heading,
    required this.points,
    required this.IVF,
    required this.files,
    required this.table,
  });

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "points": points.toList(),
        'IVF': IVF.map((image) => image.toJson()).toList(), // Fix here
        'files': files.map((file) => file.toJson()).toList(),
        'table': table.map((table) => table.toJson()).toList(),
      };

  static DescriptionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionConvertor(
        heading: json["heading"],
        points: List<String>.from(json["points"]),
        IVF: (json['IVF'] as List<dynamic>? ?? [])
            .map((item) => IVFUploader.fromJson(item))
            .toList(),
        files: (json['files'] as List<dynamic>? ?? [])
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
  final IVFUploader IVF;

  ConvertorForTRCSRC({
    required this.heading,
    required this.path,
    required this.IVF,
  });

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "path": path.toJson(),
        'IVF': IVF.toJson(), // Convert IVFUploader to JSON
      };

  static ConvertorForTRCSRC fromJson(Map<String, dynamic> json) =>
      ConvertorForTRCSRC(
        heading: json["heading"] ?? "",
        IVF: IVFUploader.fromJson(json["IVF"] ?? {}),
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
