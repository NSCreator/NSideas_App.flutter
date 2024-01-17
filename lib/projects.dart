import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsideas/textFeild.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<ProjectConvertor>> getBranchStudyMaterials(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final studyMaterialsJson = prefs.getString("projects") ?? "";

  if (studyMaterialsJson.isEmpty || isLoading) {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('projects').get();
    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("projects", projectsJson);
    List<ProjectConvertor> projects =
        projectsData.map((json) => ProjectConvertor.fromJson(json)).toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<ProjectConvertor> projects = projectsJsonList
        .map((json) => ProjectConvertor.fromJson(json))
        .toList();

    return projects;
  }
}

Future CreateSubject({
  required String id,
  required String type,
  required String youtubeLink,
  required bool isUpdate,
  required String Branch,
  required HeadingConvertor Heading,
  required String about,
  required List<String> tags,
  required List<String> tableOfContent,
  required List<convertorForTRCSRC> ComponentsAndSupplies,
  required List<convertorForTRCSRC> appAndPlatforms,
  required List<convertorForTRCSRC> toolsRequired,
  required List<DescriptionConvertor> description,
  required ImagesConvertor Images,
}) async {
  final docTrip = FirebaseFirestore.instance.collection('projects').doc(id);
  final tripData = ProjectConvertor(
    id: id,
    heading: Heading,
    youtubeLink: youtubeLink,
    description: description,
    about: about,
    toolsRequired: toolsRequired,
    Images: Images,
    ComponentsAndSupplies: ComponentsAndSupplies,
    type: type,
    tags: tags,
    tableOfContent: tableOfContent,
    appAndPlatforms: appAndPlatforms,
  );

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
}

class ProjectConvertor {
  final String id, type, about, youtubeLink;
  final HeadingConvertor heading;
  final List tableOfContent;
  final ImagesConvertor Images;
  final List tags;
  final List<DescriptionConvertor> description;
  final List<convertorForTRCSRC> ComponentsAndSupplies,
      toolsRequired,
      appAndPlatforms;

  ProjectConvertor({
    required this.id,
    required this.type,
    required this.tags,
    required this.heading,
    required this.tableOfContent,
    required this.appAndPlatforms,
    required this.youtubeLink,
    required this.ComponentsAndSupplies,
    required this.description,
    required this.about,
    required this.toolsRequired,
    required this.Images,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "about": about,
        "type": type,
        "tags": tags,
        "tableOfContent": tableOfContent,
        "youtubeLink": youtubeLink,
        "heading": heading.toJson(),
        "descriptions": description.map((unit) => unit.toJson()).toList(),
        "ComponentsAndSupplies":
            ComponentsAndSupplies.map((oldPaper) => oldPaper.toJson()).toList(),
        "toolsRequired":
            toolsRequired.map((textBook) => textBook.toJson()).toList(),
        "appAndPlatforms":
            appAndPlatforms.map((textBook) => textBook.toJson()).toList(),
        "Images": Images.toJson(),
      };

  static ProjectConvertor fromJson(Map<String, dynamic> json) =>
      ProjectConvertor(
        id: json['id'] ?? "",
        tags: List<String>.from(json['tags'] ?? []),
        heading: HeadingConvertor.fromJson(json['heading'] ?? {}),
        about: json['about'] ?? "",
        description:
            DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
        ComponentsAndSupplies:
            convertorForTRCSRC.fromMapList(json['ComponentsAndSupplies'] ?? []),
        toolsRequired:
            convertorForTRCSRC.fromMapList(json['toolsRequired'] ?? []),
        appAndPlatforms:
            convertorForTRCSRC.fromMapList(json['appAndPlatforms'] ?? []),
        Images: ImagesConvertor.fromJson(json['Images'] ?? {}),
        type: json['type'] ?? '',
        tableOfContent: json['tableOfContent'] ?? [],
        youtubeLink: json['youtubeLink'] ?? "",
      );

  static List<ProjectConvertor> fromMapList(List<dynamic> list) {
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
  final List<String> points, images;
  final List<CodeFilesConvertor> files;

  DescriptionConvertor({
    required this.heading,
    required this.points,
    required this.images,
    required this.files,
    required this.table,
  });

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "points": points.toList(),
    'images': images.toList(),
    'files': files.map((codeFilesConvertor) => codeFilesConvertor.toJson()).toList(),
    'table': table.map((tableConvertor) => tableConvertor.toJson()).toList(),
  };

  static DescriptionConvertor fromJson(Map<String, dynamic> json) => DescriptionConvertor(
    heading: json["heading"],
    points: List<String>.from(json["points"]),
    images: List<String>.from(json['images']),
    files: (json['files'] as List<dynamic>? ?? []).map((item) => CodeFilesConvertor.fromJson(item)).toList(),
    table: TableConvertor.fromMapList(json['table'] ?? []), // Change here
  );

  static List<DescriptionConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
class convertorForTRCSRC {
  final String heading, link, image;

  convertorForTRCSRC({
    required this.heading,
    required this.link,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "link": link,
        'image': image,
      };

  static convertorForTRCSRC fromJson(Map<String, dynamic> json) =>
      convertorForTRCSRC(
          heading: json["heading"] ?? "",
          image: json["image"] ?? "",
          link: json["link"] ?? "");

  static List<convertorForTRCSRC> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ImagesConvertor {
  final String main, diagram;

  ImagesConvertor({
    required this.main,
    required this.diagram,
  });

  Map<String, dynamic> toJson() => {
        "main": main,
        "diagram": diagram,
      };

  static ImagesConvertor fromJson(Map<String, dynamic> json) => ImagesConvertor(
        main: json['main'] ?? "",
        diagram: json['diagram'] ?? "",
      );

  static List<ImagesConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
