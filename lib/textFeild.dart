import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';
import 'functions.dart';


class TableConvertor {
  String col0;
  String col1;

  TableConvertor({required this.col0, required this.col1});

  Map<String, dynamic> toJson() => {
        "col0": col0,
        "col1": col1,
      };

  static TableConvertor fromJson(Map<String, dynamic> json) => TableConvertor(
        col0: json['col0'] ?? "",
        col1: json["col1"] ?? "",
      );

  static List<TableConvertor> fromMapList(List<dynamic> list) {
    return list
        .map((item) => TableConvertor.fromJson(item))
        .toList(); // Change here
  }
}

class CodeFilesConvertor {
  String heading, lang;
  String code;
  final FileUploader IVF;

  CodeFilesConvertor(
      {required this.heading,
      required this.code,
      required this.IVF,
      required this.lang});

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "code": code,
        "lang": lang,
        "ivf": IVF.toJson(),
      };

  static CodeFilesConvertor fromJson(Map<String, dynamic> json) =>
      CodeFilesConvertor(
        heading: json['heading'] ?? "",
        code: json["code"] ?? "",
        lang: json["lang"] ?? "",
        IVF: FileUploader.fromJson(json["ivf"] ?? {}),
      );

  static List<CodeFilesConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
