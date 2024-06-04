// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nsideas/apps/convertor.dart';
import 'package:nsideas/project_files/projects.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/home_page/searchBar.dart';
import 'package:nsideas/sensors/converter.dart';
import 'package:nsideas/sensors/sensor_components.dart';

import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/shopping/Converter.dart';
import 'package:nsideas/shopping/shopping_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ads/ads.dart';
import '../apps/apps.dart';
import '../board/board.dart';
import '../board/converter.dart';
import '../favorites/favorites.dart';
import '../functions.dart';
import '../message/messaging_page.dart';
import '../notifications/converter.dart';
import '../notifications/notification_page.dart';
import '../shopping/sub_page.dart';
import '../test.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  List<ProjectConverter> projects;
  List<BoardsConverter> boards;

  List<SensorsConverter> sensors;
  List<NotificationConverter> notification;

  List<ProductsConverter> products;

  List<AppsConverter> apps;
  List<HomePageImagesConvertor> HomePageImages;

  HomePage(
      {required this.projects,
      required this.apps,
      required this.boards,
      required this.notification,
      required this.sensors,
      required this.products,
      required this.HomePageImages});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tabBatList = [
    "Board",
    "Sensors",
    "Projects",
    "Products",
  ];
  List searchList = [
    "Search About",
    "Boards",
    "Projects",
    "Sensors",
    "Products"
  ];

  getAd(BuildContext context) {
    HomePageAd homePageAd = HomePageAd(context, type: "homepage");

    homePageAd.startAdLoading();
  }

  List<String> tab1 = ["Boards", "Sensors"];
  List<String> tab1_img = ["uno.png", "sensors.png"];
  List<String> tab2 = ["Products", "Apps"];

  Widget IconContainer(
      {required Color ContainerColor,
      required IconData icon,
      required Color IconColor,
      required String text,
      required Color TextColor}) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: ContainerColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: IconColor,
          ),
          Text(
            " $text ",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: TextColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ExternalLaunchUrl("https://www.youtube.com/@NSIdeas");
                      },
                      child: Text(
                        'NS Ideas          ',
                        style: GoogleFonts.dancingScript(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage(
                                          notification: widget.notification,
                                        )));
                          },
                          child: badges.Badge(
                            badgeContent: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(
                              Icons.notifications_none,
                              color: Colors.white70,
                              size: 25,
                            ),
                          ),
                        ),


                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => searchBar(
                                        projects: widget.projects,
                                      )));
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900,
                            border: Border.all(
                                color: Colors.black.withOpacity(0.05)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white54,
                                  size: 35,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Search Here --- Testing ---",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                      InkWell(
                        onTap: () {
                          if (!isAnonymousUser()){
                            if (isOwner()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => notifications()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => notification(email: "",)));
                            }
                          }else{
                            showToastText("Please LogIn");
                          }

                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 8,
                          ),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.message,
                            color: Colors.white60,
                            size: 30,
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => favorites()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8, right: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white60,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                HeadingH2(heading: "Categories"),
                SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ListView(
                          padding: EdgeInsets.only(left: 10),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            // SizedBox(height: 50,width: 50,child: Image.asset("assets/img.png"),),
                            InkWell(
                                onTap: () {
                                  showToastText("Home Page");
                                },
                                child: IconContainer(
                                    ContainerColor: Colors.blueGrey.shade900,
                                    text: "Home",
                                    icon: Icons.home,
                                    IconColor: Colors.white54,
                                    TextColor: Colors.white)),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Projects(
                                              projects: widget.projects)));
                                },
                                child: IconContainer(
                                    ContainerColor: Colors.blueGrey.shade900,
                                    text: "Projects",
                                    icon: Icons.handyman_rounded,
                                    IconColor: Colors.white54,
                                    TextColor: Colors.white)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Apps(
                                              appsData: widget.apps,
                                            )));
                              },
                              child: IconContainer(
                                  ContainerColor: Colors.blueGrey.shade900,
                                  text: "Apps",
                                  icon: Icons.apps,
                                  IconColor: Colors.white54,
                                  TextColor: Colors.white),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => ShoppingPage(
                            //                   products: widget.products,
                            //                 )));
                            //   },
                            //   child:IconContainer(
                            //       ContainerColor: Colors.blueGrey.shade900,
                            //       text: "Products",
                            //       icon: Icons.shopping_bag,
                            //       IconColor: Colors.white70,
                            //       TextColor: Colors.white),
                            // ),
                          ],
                        ),
                        ListView.builder(
                            padding: EdgeInsets.only(right: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: tab1.length,
                            itemBuilder: (context, int index) {
                              final data = tab1[index];
                              return InkWell(
                                onTap: () {
                                  if (data == "Boards")
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Boards(
                                                  boardName: '',
                                                  boards: widget.boards,
                                                )));
                                  else if (data == "Sensors")
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sensorsAndComponents(
                                                    sensors: widget.sensors)));
                                  else
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                                    body: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    backButton(),
                                                    Projects(
                                                      projects: widget.projects,
                                                    ),
                                                  ],
                                                ))));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3.0,vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueGrey.shade900),
                                  child: Row(
                                    children: [
                                      Text(
                                        " $data",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
                if (widget.HomePageImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: scrollingImages(
                        images: widget.HomePageImages.map(
                            (HomePageImage) => HomePageImage.image).toList(),
                        id: "HomePageImages",
                        isZoom: true,
                        ar: AspectRatio(
                          aspectRatio: 16 / 5,
                        )),
                  ),
                headingWithPath(
                    heading: "Projects",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Projects(
                                    projects: widget.projects,
                                  )));
                    }),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: widget.projects.length,
                  itemBuilder: (context, index) {
                    final data = widget.projects[index];
                    bool _isTapped = false;

                    return GestureDetector(
                      onTap: () async {
                        if (isOwner()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Project(data: data),
                            ),
                          );
                          showToastText("Owner Mode");
                        } else if (!_isTapped) {
                          _isTapped = true;
                          Future.delayed(Duration(seconds: 2), () {
                            _isTapped = false;
                          });
                          if (!data.isFree) {
                            showToastText("Buying Option: Coming Soon");
                          } else if (data.isContainsAds && data.isFree) {
                            bool ad = await HomePageAd(context, type: data.id)
                                .startAdLoading();

                            if (ad) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Project(data: data),
                                ),
                              );
                            } else {
                              showToastText(
                                  "Error with Ad, Please Message Owner");
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Project(data: data),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: data.thumbnail.fileUrl.isNotEmpty
                                        ? ImageShowAndDownload(
                                            image: data.thumbnail.fileUrl,
                                            id: "projects",
                                            isZoom: false,
                                          )
                                        : Container(),
                                  ),
                                ),
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      child: Text(
                                        data.type,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (!data.isFree)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.red),
                                            child: Text(
                                              "Buy It",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          )
                                        else if (data.isContainsAds)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 10),

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black),
                                            child: Text(
                                              "Ad Lock",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                      ],
                                    )),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "${data.heading.short}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget headingWithPath({
    required String heading,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Text(
              "See All",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsScrolling extends StatefulWidget {
  List<ProductsConverter> data;

  ProductsScrolling({required this.data});

  @override
  State<ProductsScrolling> createState() => _ProductsScrollingState();
}

class _ProductsScrollingState extends State<ProductsScrolling> {
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CarouselSlider.builder(
                    itemCount: widget.data.length,
                    options: CarouselOptions(
                        aspectRatio: 16 / 6,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: widget.data.length > 1 ? true : false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPos = index;
                          });
                        }),
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      return ImageShowAndDownload(
                        image: widget.data[itemIndex].images.first,
                        id: widget.data[itemIndex].id,
                        isZoom: false,
                      );
                    }),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.data.map((url) {
                      int index = widget.data.indexOf(url);
                      return Container(
                        width: 5.0,
                        height: 5.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPos == index
                              ? Colors.white
                              : Colors.white24,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data[currentPos].heading,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹ ${widget.data[currentPos].cost - widget.data[currentPos].cost * (widget.data[currentPos].discount / 100)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                " ${widget.data[currentPos].discount}%",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                            ),
                            Text(
                              "₹ ${widget.data[currentPos].cost}",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                widget.data[currentPos].availability,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class projectShowingContainer extends StatefulWidget {
  ProjectConverter data;

  projectShowingContainer({super.key, required this.data});

  @override
  State<projectShowingContainer> createState() =>
      _projectShowingContainerState();
}

class _projectShowingContainerState extends State<projectShowingContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.black12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: widget.data.thumbnail.fileUrl.isNotEmpty
                    ? ImageShowAndDownload(
                        image: widget.data.thumbnail.fileUrl,
                        id: "projects",
                        isZoom: false,
                      )
                    : Container(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.data.heading.short}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Text(
                          widget.data.type,
                          style: TextStyle(
                            // color: Colors.white70,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "${widget.data.heading.full}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!widget.data.isFree)
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: Text(
                            "Buy It",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      else if (widget.data.isContainsAds)
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: Text(
                            "Ad Lock",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<HomePageImagesConvertor>> getHomePageImages(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final studyMaterialsJson = prefs.getString("HomePageImages") ?? "";

  if (studyMaterialsJson.isEmpty || isLoading) {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('HomePageImages').get();
    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("HomePageImages", projectsJson);
    List<HomePageImagesConvertor> projects = projectsData
        .map((json) => HomePageImagesConvertor.fromJson(json))
        .toList();
    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(studyMaterialsJson);
    List<HomePageImagesConvertor> projects = projectsJsonList
        .map((json) => HomePageImagesConvertor.fromJson(json))
        .toList();

    return projects;
  }
}

class HomePageImagesConvertor {
  String id;
  final String image;

  HomePageImagesConvertor({
    this.id = "",
    required this.image,
  });

  static HomePageImagesConvertor fromJson(Map<String, dynamic> json) =>
      HomePageImagesConvertor(
        id: json['id'],
        image: json["image"],
      );
}

Stream<List<HomePageImagesConvertor>> readHomePageImagesConvertor() =>
    FirebaseFirestore.instance.collection("HomePageImages").snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => HomePageImagesConvertor.fromJson(doc.data()))
            .toList());

Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18, timeInSecForIosWeb: 5);
}

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}
