// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsideas/apps/creator.dart';
import 'package:nsideas/auth/logIn_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/shopping/orders.dart';
import 'package:nsideas/textFeild.dart';

import '../apps/convertor.dart';
import '../board/text_field.dart';
import '../functions.dart';

import 'dart:async';

import '../notifications/creator.dart';
import '../sensors/creator.dart';
import '../shopping/all_orders.dart';
import '../test.dart';

String noImageUrl = "No Photo Url Available";
String longPressToViewImage = "Long Press To View Image";
final String token = '7145103395:AAExw7kwzFyB6lKcEDn4IxEl_7QyTomFhEE';//NsIdeas
// final String token = '7152765208:AAFtlX5uwyoa4kL2Ie_jj3nxTVm_IOmiMxk';//tester
final String telegramId = '1314922309';
const TextStyle HeadingsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

FullUser() {
  return FirebaseAuth.instance.currentUser!.email! ?? "";
}

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    String greeting = 'Hello';
    if (currentHour >= 18) {
      greeting = 'Good Evening';
    } else if (currentHour >= 12) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Morning';
    }
    return Scaffold(

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "User Details",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: Text(
                    '$greeting,',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    Text(
                      isAnonymousUser() ? "Guest" : userId().split("@").first,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => orders_page())),
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 30,
                          ),
                          Text(
                            " My Orders",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30,
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                if (isOwner())
                  Container(
                    child: Column(
                      children: [
                        // Uploader(onChanged: (e){}, type: FileType.any),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => all_orders_page())),
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    " All Orders",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 30,
                                  ),
                                ],
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AppCreator()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Create Apps",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationCreator()));
                            },
                            child: Text("Notification")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          arduinoBoardCreator()));
                            },
                            child: Text("Boards")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SensorsCreator()));
                            },
                            child: Text("Sensors")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectCreator()));
                            },
                            child: Text("Create Project")),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            width: double.infinity,
                            child: const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Text(
                                "Add Arduino Board",
                                style: TextStyle(
                                    fontSize: 23, color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        arduinoBoardCreator()));
                          },
                        ),
                      ],
                    ),
                  ),
                Center(
                  child: Text(
                    "Developed and designed by Nimmala Sujith.",
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        "Contact: ",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        "sujithnimmala03@gmail.com",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Testing Mode",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          isAnonymousUser() ? "LogOut as Guest" : "Log Out",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ));
  }
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => followUsConvertor.fromJson(doc.data()))
        .toList());

class followUsConvertor {
  String id;
  final String name, link, photoUrl;

  followUsConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          photoUrl: json["photoUrl"]);
}
