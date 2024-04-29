// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  List<AppsConvertor> apps;
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

  @override
  void initState() {
    super.initState();
    HomePageAd();
  }

  List<String> tab1 = ["Boards", "Sensors"];
  List<String> tab1_img = ["uno.png", "sensors.png"];
  List<String> tab2 = ["Products", "Apps"];

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
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => settings()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black12)),
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          ExternalLaunchUrl("https://www.youtube.com/@NSIdeas");
                        },
                        child: GradientAnimationText(
                          text: Text(
                            'NS Ideas',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                          colors: [
                            Color.fromRGBO(7, 24, 2, 1),
                            Color.fromRGBO(7, 24, 2, 1),
                            Color.fromRGBO(7, 24, 2, 1),
                            Color.fromRGBO(7, 24, 2, 1),
                            Color.fromRGBO(113, 154, 163, 0.5),
                          ],
                          duration: Duration(seconds: 6),
                        ),
                      ),
                      Text(
                        "Welcome ${userId().split("@").first},",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(0.8)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      if (!isAnonymousUser())
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => notifications()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.message,
                            ),
                          ),
                        ),
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
                            '1',
                            style: TextStyle(color: Colors.white),
                          ),
                          child: Icon(Icons.notifications_none),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
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
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.04),
                        border: Border.all(color: Colors.black.withOpacity(0.05)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Icon(
                              Icons.search,
                              color: Colors.black45,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Search Here --- Testing ---",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => favorites()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      // border: Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 30,
                    ),
                  ),
                ),
              ],
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      showToastText("Home Page");
                    },
                    child: Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(11, 29, 41, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white54,
                          ),
                          Text(
                            " Home",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Projects(projects: widget.projects)));
                    },
                    child: Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.handyman_rounded,
                            color: Colors.black54,
                          ),
                          Text(
                            " Projects",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Apps( appsData: widget.apps,)));
                    },
                    child: Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apps,
                            color: Colors.black54,
                          ),
                          Text(
                            " Apps",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShoppingPage(products: widget.products,)));
                    },
                    child: Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Colors.black54,
                          ),
                          Text(
                            " Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            headingWithPath(
              heading: "Products",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShoppingPage(
                  products: widget.products,
                )));
              },
            ),
            if (widget.products.isNotEmpty)
              ProductsScrolling(
                data: widget.products,
              ),
            ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.products.length,
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  final data = widget.products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage(
                                    data: data,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                      aspectRatio: 15 / 9,
                                      child: Image.network(
                                        data.images.first,
                                        fit: BoxFit.cover,
                                      )))),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.heading,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "₹ ${data.cost - data.cost * (data.discount / 100)}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
            if (!widget.products.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.black54,
                    ),
                    Text(
                      "  Unavailable Products",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            headingWithPath(
              heading: "Apps",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Apps(
                              appsData: widget.apps,
                            )));
              },
            ),
            ListView.builder(
                padding: EdgeInsets.only(bottom: 5, left: 10, right: 5),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.apps.length,
                itemBuilder: (context, int index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ImageShowAndDownload(
                              id: "app",
                              image: widget.apps[index].icon.file_url,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.apps[index].name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.apps[index].supported.join(","),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.circle,
                                  size: 5,
                                ),
                              ),
                              Text(
                                widget.apps[index].supportsAds
                                    ? "Contains Ads"
                                    : "Ad Free",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.apps[index].size,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.circle,
                                  size: 5,
                                ),
                              ),
                              Text(
                                "V${widget.apps[index].version}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      )),
                      InkWell(
                          onTap: () {
                            if (widget.apps[index].playStoreLink.isNotEmpty)
                              ExternalLaunchUrl(widget.apps[index].playStoreLink);
                            else
                              showToastText("Unavailable");
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Get It",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ))
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                  height: 35,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      builder: (context) => sensorsAndComponents(
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
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.08)),
                            child: Row(
                              children: [
                                Image.asset("assets/${tab1_img[index]}"),
                                Text(
                                  " $data",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ),
            headingWithPath(
                heading: "Projects",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Projects(
                    projects: widget.projects,
                  )));
                }),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = widget.projects[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Project(data: data),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                    child: projectShowingContainer(
                      data: data,
                    ),
                  ),
                );
              },
              itemCount: widget.projects.length,
            ),
            SizedBox(
              height: 120,
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
                fontSize: 25,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: widget.data.images.isNotEmpty
                      ? ImageShowAndDownload(
                          image: widget.data.images.first.file_url,
                          id: "projects",
                          isZoom: false,
                        )
                      : Container(),
                ),
              ),
              Positioned(
                  bottom: 5,
                  left: 5,
                  right: 5,
                  child: Text(
                    "${widget.data.heading.short}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  )),
              Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Text(
                      widget.data.type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
          Text(
            "${widget.data.heading.full}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isOwner())
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProjectCreator(
                                data: widget.data,
                              )));
                },
                icon: Icon(Icons.edit))
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
