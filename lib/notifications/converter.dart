import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<NotificationConverter>> getNotification(bool isReload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final studyMaterialsJson = prefs.getString("notifications") ?? "";

  if (studyMaterialsJson.isEmpty||isReload ) {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('notifications').orderBy("id",descending: true).get();
    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("notifications", projectsJson);
    List<NotificationConverter> projects =
    projectsData.map((json) => NotificationConverter.fromJson(json)).toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<NotificationConverter> projects = projectsJsonList
        .map((json) => NotificationConverter.fromJson(json))
        .toList();

    return projects;
  }
}

class NotificationConverter {
  final String id;
  final String heading;
  final List<String> image;
  final String youtube;
  final String description;

  NotificationConverter({
    this.id = "",
    required this.heading,
    required this.description,
    required this.image,
    required this.youtube,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading,
    'image': image,
    'youtube': youtube,
    'description': description,
  };

  static NotificationConverter fromJson(Map<String, dynamic> json) {
    // Convert image field to list if it's a string
    var imageJson = json["image"];
    List<String> imageList = [];
    if (imageJson is String) {
      // Convert the string to a list with one element
      imageList = [imageJson];
    } else if (imageJson is List) {
      // Use the list as is
      imageList = List<String>.from(imageJson);
    }

    return NotificationConverter(
      id: json['id'] ?? "",
      heading: json["heading"],
      image: imageList,
      youtube: json["youtube"],
      description: json["description"],
    );
  }

  static List<NotificationConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}


Stream<List<NotificationConverter>> readNotifications() => FirebaseFirestore.instance
    .collection('notifications')
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => NotificationConverter.fromJson(doc.data()))
    .toList());
