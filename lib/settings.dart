// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/projects.dart';
import 'package:nsideas/textFeild.dart';

import 'functions.dart';

import 'dart:async';


import 'homePage.dart';

String noImageUrl = "No Photo Url Available";
String longPressToViewImage = "Long Press To View Image";

const TextStyle HeadingsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

isUser() {
  return false;
  // return FirebaseAuth.instance.currentUser!.email! == "sujithnimmala03@gmail.com";
}

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return backGroundImage(
        text: "Settings",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser())
              ElevatedButton(
                  onPressed: () {
                    CreateSubject(
                        id: getID(),
                        youtubeLink: "sdasdsad",
                        isUpdate: false,
                        Branch: "",
                        Heading: HeadingConvertor(full: "full", short: "short"),
                        about: "Description",
                        ComponentsAndSupplies: [
                          convertorForTRCSRC(
                              heading: "heading", link: "link", image: "image")
                        ],
                        toolsRequired: [
                          convertorForTRCSRC(
                              heading: "heading", link: "link", image: "image")
                        ],
                        description: [],
                        Images: ImagesConvertor(
                            main:
                                "https://c1.wallpaperflare.com/preview/398/896/843/arduino-electronics-integrated-circuit-ic.jpg",
                            diagram:
                                "https://img.youtube.com/vi/5Wpju1yZulY/maxresdefault.jpg"),
                        type: 'Arduino',
                        tags: ["BC547", "Arduino", "projects"],
                        tableOfContent: [
                          "table of content",
                          "lldflkdfw",
                          "wrjfhwjhfjrfrf"
                        ],
                        appAndPlatforms: [
                          convertorForTRCSRC(
                              heading: "heading", link: "link", image: "image")
                        ]);
                  },
                  child: Text("Create Project")),
            if (isUser())InkWell(
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
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => arduinoBoardCreator()));
              },
            ),


            StreamBuilder<List<followUsConvertor>>(
                stream: readfollowUs(),
                builder: (context, snapshot) {
                  final Books = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ));
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        if (Books!.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No Treading Projects",
                                style: TextStyle(
                                  color: Color.fromRGBO(195, 228, 250, 1),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            padding:
                                EdgeInsets.only(top: 10, bottom: 15, left: 10),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "Follow Us",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Books.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 20 : 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  174, 228, 242, 0.15),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            // border: Border.all(color: Colors.white),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      Books[index].photoUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                height: 35,
                                                width: 50,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Books[index].name,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                  }
                }),

            // Center(
            //   child: InkWell(
            //       child: Padding(
            //         padding: const EdgeInsets.only(top: 20, bottom: 20),
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(15),
            //             color: Colors.black.withOpacity(0.1),
            //           ),
            //           child: const Padding(
            //             padding: EdgeInsets.only(
            //                 left: 13, right: 13, top: 8, bottom: 8),
            //             child: Text(
            //               "Log Out",
            //               style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w800),
            //             ),
            //           ),
            //         ),
            //       ),
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (context) {
            //             return Dialog(
            //               backgroundColor: Colors.black.withOpacity(0.4),
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(20)),
            //               elevation: 16,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   border: Border.all(color: Colors.white30),
            //                   borderRadius: BorderRadius.circular(20),
            //                 ),
            //                 child: ListView(
            //                   shrinkWrap: true,
            //                   children: <Widget>[
            //                     const SizedBox(height: 10),
            //                     const SizedBox(height: 5),
            //                     const Padding(
            //                       padding: EdgeInsets.only(left: 15),
            //                       child: Text(
            //                         "Do you want Log Out",
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.w600,
            //                             fontSize: 18),
            //                       ),
            //                     ),
            //                     const SizedBox(
            //                       height: 5,
            //                     ),
            //                     Center(
            //                       child: Row(
            //                         mainAxisAlignment:
            //                         MainAxisAlignment.center,
            //                         crossAxisAlignment:
            //                         CrossAxisAlignment.center,
            //                         children: [
            //                           const Spacer(),
            //                           // InkWell(
            //                           //   child: Container(
            //                           //     decoration: BoxDecoration(
            //                           //       color: Colors.white24,
            //                           //       border: Border.all(
            //                           //           color: Colors.black),
            //                           //       borderRadius:
            //                           //       BorderRadius.circular(25),
            //                           //     ),
            //                           //     child: const Padding(
            //                           //       padding: EdgeInsets.only(
            //                           //           left: 15,
            //                           //           right: 15,
            //                           //           top: 5,
            //                           //           bottom: 5),
            //                           //       child: Text(
            //                           //         "Back",
            //                           //         style: TextStyle(
            //                           //             color: Colors.white),
            //                           //       ),
            //                           //     ),
            //                           //   ),
            //                           //   onTap: () {
            //                           //     Navigator.pop(context);
            //                           //   },
            //                           // ),
            //                           const SizedBox(
            //                             width: 10,
            //                           ),
            //                           // InkWell(
            //                           //   child: Container(
            //                           //     decoration: BoxDecoration(
            //                           //       color: Colors.red,
            //                           //       border: Border.all(
            //                           //           color: Colors.black),
            //                           //       borderRadius:
            //                           //       BorderRadius.circular(25),
            //                           //     ),
            //                           //     child: const Padding(
            //                           //       padding: EdgeInsets.only(
            //                           //           left: 15,
            //                           //           right: 15,
            //                           //           top: 5,
            //                           //           bottom: 5),
            //                           //       child: Text(
            //                           //         "Log Out",
            //                           //         style: TextStyle(
            //                           //             color: Colors.white),
            //                           //       ),
            //                           //     ),
            //                           //   ),
            //                           //   onTap: () {
            //                           //     FirebaseAuth.instance.signOut();
            //                           //     Navigator.pushReplacement(
            //                           //         context,
            //                           //         MaterialPageRoute(
            //                           //             builder: (context) =>
            //                           //                 LoginPage()));
            //                           //   },
            //                           // ),
            //                           const SizedBox(
            //                             width: 20,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     const SizedBox(
            //                       height: 10,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       }),
            // ),
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
          ],
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
