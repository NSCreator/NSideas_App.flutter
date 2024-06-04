import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../uploader/telegram_uploader.dart';

class AppsConverter {
  final String name, id;
  final String version;
  final String size;
  final bool supportsAds;
  final bool inAppPurchases;
  final Developer developer;
  final List<String> appSupportedDevices;
  final List<String> appSupportedLanguages;
  final String about;
  final String updateDate;
  final List<String> points;
  final FileUploader icon;
  final List<FileUploader> images;
  final List<AppDownloadLinks> appDownloadLinks;

  AppsConverter({
    required this.name,
    required this.id,
    required this.version,
    required this.size,
    required this.supportsAds,
    required this.inAppPurchases,
    required this.developer,
    required this.appSupportedDevices,
    required this.appSupportedLanguages,
    required this.about,
    required this.updateDate,
    required this.points,
    required this.icon,
    required this.images,
    required this.appDownloadLinks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'size': size,
      'supportsAds': supportsAds,
      'inAppPurchases': inAppPurchases,
      'developer': developer.toJson(),
      'appSupportedDevices': appSupportedDevices,
      'appSupportedLanguages': appSupportedLanguages,
      'about': about,
      'updateDate': updateDate,
      'points': points,
      'icon': icon.toJson(),
      'screenshots': images.map((screenshot) => screenshot.toJson()).toList(),
      'appDownloadLinks': appDownloadLinks.map((link) => link.toJson()).toList(),
    };
  }

  factory AppsConverter.fromJson(Map<String, dynamic> json) {
    return AppsConverter(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      size: json['size'],
      supportsAds: json['supportsAds'] ?? false,
      inAppPurchases: json['inAppPurchases'] ?? false,
      developer: Developer.fromJson(json['developer']),
      appSupportedDevices: List<String>.from(json['appSupportedDevices']),
      appSupportedLanguages: List<String>.from(json['appSupportedLanguages']),
      about: json['about'],
      updateDate: json['updateDate'],
      points: List<String>.from(json['points']),
      icon: FileUploader.fromJson(json['icon']),
      images: (json['screenshots'] as List<dynamic>).map((screenshot) => FileUploader.fromJson(screenshot)).toList(),
      appDownloadLinks: (json['appDownloadLinks'] as List<dynamic>).map((link) => AppDownloadLinks.fromJson(link)).toList(),
    );
  }
}

class Developer {
  final String name;
  final String website;
  final String email;

  Developer({
    required this.name,
    required this.website,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'website': website,
      'email': email,
    };
  }

  factory Developer.fromJson(Map<String, dynamic> json) {
    return Developer(
      name: json['name'],
      website: json['website'],
      email: json['email'],
    );
  }
}

class AppDownloadLinks {
  final String platform;
  final String link;

  AppDownloadLinks({
    required this.platform,
    required this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'link': link,
    };
  }

  factory AppDownloadLinks.fromJson(Map<String, dynamic> json) {
    return AppDownloadLinks(
      platform: json['platform'],
      link: json['link'],
    );
  }
}


Future<List<AppsConverter>> getApps(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final studyMaterialsJson = prefs.getString("apps") ?? "";

  if (studyMaterialsJson.isEmpty || isLoading) {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('apps').get();
    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("apps", projectsJson);
    List<AppsConverter> projects =
    projectsData.map((json) => AppsConverter.fromJson(json)).toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<AppsConverter> projects = projectsJsonList
        .map((json) => AppsConverter.fromJson(json))
        .toList();

    return projects;
  }
}