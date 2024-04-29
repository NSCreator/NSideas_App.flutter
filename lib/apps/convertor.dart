import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';
import '../uploader/telegram_uploader.dart';

class AppsConvertor {
  final String name,id;
  final String bundleId;
  final String version;
  final String size;
  final bool supportsAds;
  final bool inAppPurchases;
  final Developer developer;
  final List<String> supported;
  final List<String> platforms;
  final List<String> languages;
  final String about;
  final String updateDate;
  final List<String> description;
  final IVFUploader icon;
  final List<IVFUploader> screenshots;
  final String appStoreLink;
  final String playStoreLink;

  AppsConvertor({
    required this.name,
    required this.id,
    required this.bundleId,
    required this.version,
    required this.size,
    required this.supportsAds,
    required this.inAppPurchases,
    required this.developer,
    required this.supported,
    required this.platforms,
    required this.languages,
    required this.about,
    required this.updateDate,
    required this.description,
    required this.icon,
    required this.screenshots,
    required this.appStoreLink,
    required this.playStoreLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bundle_id': bundleId,
      'version': version,
      'size': size,
      'supports_ads': supportsAds,
      'in_app_purchases': inAppPurchases,
      'developer': developer.toJson(),
      'supported': supported,
      'platforms': platforms,
      'languages': languages,
      'about': about,
      'update_date': updateDate,
      'description': description,
      'icon': icon.toJson(), // Corrected this line
      'screenshots': screenshots.map((screenshot) => screenshot.toJson()).toList(), // Corrected this line
      'app_store_link': appStoreLink,
      'play_store_link': playStoreLink,
    };
  }

  factory AppsConvertor.fromJson(Map<String, dynamic> json) {
    return AppsConvertor(
      id: json['id'],
      name: json['name'],
      bundleId: json['bundle_id'],
      version: json['version'],
      size: json['size'],
      supportsAds: json['supports_ads'] ?? false,
      inAppPurchases: json['in_app_purchases'] ?? false,
      developer: Developer.fromJson(json['developer']),
      supported: List<String>.from(json['supported']),
      platforms: List<String>.from(json['platforms']),
      languages: List<String>.from(json['languages']),
      about: json['about'],
      updateDate: json['update_date'],
      description: List<String>.from(json['description']),
      icon: IVFUploader.fromJson(json['icon']), // Corrected this line
      screenshots: (json['screenshots'] as List<dynamic>).map((screenshot) => IVFUploader.fromJson(screenshot)).toList(), // Corrected this line
      appStoreLink: json['app_store_link'],
      playStoreLink: json['play_store_link'],
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


Future<List<AppsConvertor>> getApps(bool isLoading) async {
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
    List<AppsConvertor> projects =
    projectsData.map((json) => AppsConvertor.fromJson(json)).toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<AppsConvertor> projects = projectsJsonList
        .map((json) => AppsConvertor.fromJson(json))
        .toList();

    return projects;
  }
}