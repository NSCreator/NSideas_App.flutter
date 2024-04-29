
import 'dart:convert';

import 'package:nsideas/project_files/projects_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedProjectsPreferences {
  static const String key = "saved_projects";

  static Future<void> save(List<ProjectConverter> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  static Future<List<ProjectConverter>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => ProjectConverter.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> add(ProjectConverter newSubject) async {
    final List<ProjectConverter> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  static Future<void> delete(String subjectId) async {
    List<ProjectConverter> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}

