import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsideas/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../project_files/projects_test.dart';
import '../textFeild.dart';

class SubjectPreferences {
  static const String key = "cart";

  static Future<void> save(List<ProductsConverter> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  // Get a list of subjects from shared preferences
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
  static Future<void> updateQuantity(String subjectId, int newQuantity) async {
    List<ProductsConverter> subjects = await get();
    final index = subjects.indexWhere((subject) => subject.id == subjectId);
    if (index != -1) {
      subjects[index].quantity = newQuantity;
      await save(subjects);
    }
  }

// Add a new subject to shared preferences if it's not already present
  static Future<void> add(ProductsConverter newSubject) async {
    final List<ProductsConverter> subjects = await get();
    // Check if the subject with the same ID already exists
    final index = subjects.indexWhere((subject) => subject.id == newSubject.id);
    if (index == -1) {
      subjects.add(newSubject);
      await save(subjects);
    }else{
      showToastText("All Ready Present");
    }
  }


  // Delete a subject from shared preferences
  static Future<void> delete(String subjectId) async {
    List<ProductsConverter> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}
Stream<List<ProductsConverter>> readSRKRFlashNews() =>
    FirebaseFirestore.instance
        .collection("products")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductsConverter.fromJson(doc.data()))
        .toList());


class ProductsConverter {
  final String id;
  final List<String> type;
  final String heading;
  final String projectId;
  final String availability;
  final String about;
   int cost,quantity;
  final int discount;
  final List<TableConvertor> specificationDetails;
  final List<String> images;
  final List<ProductDetailsConvertor> productDetails;

  final List<ProductReviewsConvertor> reviews;

  ProductsConverter({
    required this.id,
    required this.type,
    required this.heading,
    required this.quantity,
    required this.projectId,
    required this.availability,
    required this.about,
    required this.cost,
    required this.discount,
    required this.specificationDetails,
    required this.images,
    required this.productDetails,
    required this.reviews,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'heading': heading,
    'projectId': projectId,
    'availability': availability,
    'quantity': quantity,
    'about': about,
    'cost': cost,
    'discount': discount,
    'specificationDetails': specificationDetails.map((spec) => spec.toJson()).toList(),
    'images': images,
    'productDetails': productDetails.map((detail) => detail.toJson()).toList(),
    'reviews': reviews.map((review) => review.toJson()).toList(),
  };

  static ProductsConverter fromJson(Map<String, dynamic> json) => ProductsConverter(
    id: json['id'] ?? "",
    type: List<String>.from(json['type'] ?? []),
    heading: json['heading'] ?? "",
    projectId: json['projectId'] ?? "",
    availability: json['availability'] ?? "",
    quantity: json['quantity'] ?? 1,
    about: json['about'] ?? "",
    cost: json['cost'] ?? 0,
    discount: json['discount'] ?? 0,
    specificationDetails: TableConvertor.fromMapList(json['specificationDetails'] ?? []),
    images: List<String>.from(json['images'] ?? []),
    productDetails: ProductDetailsConvertor.fromMapList(json['productDetails'] ?? []),
    reviews: ProductReviewsConvertor.fromMapList(json['reviews'] ?? []),
  );

  static List<ProductsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ProductDetailsConvertor {
  final String heading;
  final String subHeading;
  final List<String> points;

  ProductDetailsConvertor({
    required this.heading,
    required this.subHeading,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "subHeading": subHeading,
    "points": points,
  };

  static ProductDetailsConvertor fromJson(Map<String, dynamic> json) =>
      ProductDetailsConvertor(
        heading: json['heading'] ?? "",
        subHeading: json["subHeading"] ?? "",
        points: List<String>.from(json["points"] ?? []),
      );

  static List<ProductDetailsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ProductReviewsConvertor {
  final String reviewId;
  final String userId;
  final String comment,heading;
  final String date;
  final String username;
  final String userLocation;
  final String userAvatar;
  final double rating;
  final List<String> images;

  ProductReviewsConvertor({
    required this.rating,
    required this.reviewId,
    required this.userAvatar,
    required this.heading,
    required this.userId,
    required this.userLocation,
    required this.username,
    required this.date,
    required this.comment,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "review_id": reviewId,
    "user_avatar": userAvatar,
    "heading": heading,
    "user_id": userId,
    "user_location": userLocation,
    "username": username,
    "date": date,
    "comment": comment,
    "images": images,
  };

  static ProductReviewsConvertor fromJson(Map<String, dynamic> json) =>
      ProductReviewsConvertor(
        rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
        reviewId: json["review_id"] ?? "",
        userAvatar: json["user_avatar"] ?? "",
        heading: json["heading"] ?? "",
        userId: json["user_id"] ?? "",
        userLocation: json["user_location"] ?? "",
        username: json["username"] ?? "",
        date: json["date"] ?? "",
        comment: json["comment"] ?? "",
        images: List<String>.from(json["images"] ?? []),
      );

  static List<ProductReviewsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
