import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../shopping/Converter.dart';

class SavedProductsPreferences {
  static const String key = "saved_shopping";

  static Future<void> save(List<ProductsConverter> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  static Future<List<ProductsConverter>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => ProductsConverter.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> add(ProductsConverter newSubject) async {
    final List<ProductsConverter> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  static Future<void> delete(String subjectId) async {
    List<ProductsConverter> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}

