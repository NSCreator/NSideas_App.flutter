// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:nsideas/projects.dart';
import 'package:nsideas/searchBar.dart';
import 'package:nsideas/settings.dart';
import 'package:nsideas/subPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'authPage.dart';
import 'main.dart';
class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/9491925792';
    }else {
      return 'ca-app-pub-7097300908994281/8849115979';
    }
  }
}
class HomePage extends StatefulWidget {
  // final List<ProjectsConvertor> data;

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List searchList = ["Search About", "Arduino", "Raspberry Pi", "Sensors"];
  List tabBatList = [
    "Arduino & ESP",
    "Raspberry Pi",
    "Electronics",
    "Sensors",
  ];

  late final RewardedAd rewardedAd;
  bool isAdLoaded = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double remainingTime = 0;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdVideo.bannerAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
        },
        onAdLoaded: (RewardedAd ad) async {
          print("$ad loaded");
          showToastText("Add loaded");
          rewardedAd = ad;
          _setFullScreenContentCallback();
          await _showRewardedAd();
          final user = _auth.currentUser;
          if (user != null) {
            final imageRef = _firestore
                .collection('users')
                .doc(fullUserId());
            await imageRef.update({
              'lastOpenAdTime':
              FieldValue.serverTimestamp(),
            });
          }




        },
      ),
    );
  }

  //method to set show content call back
  void _setFullScreenContentCallback() {
    if (rewardedAd == null) {
      return;
    }
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      //when ad  shows fullscreen
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print("$ad onAdShowedFullScreenContent"),
      //when ad dismissed by user
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");

        //dispose the dismissed ad
        ad.dispose();
      },
      //when ad fails to show
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad  onAdFailedToShowFullScreenContent: $error ");
        //dispose the failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
    );
  }

  Future<void> _showRewardedAd() async {
    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          num amount = rewardItem.amount;
          showToastText("You earned: $amount");

        });
    final imageRef = _firestore.collection("user").doc(fullUserId());

    final documentSnapshot = await imageRef.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      if (data['adSeenCount']==null) {
        _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":0});
      } else {
        _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":data['adSeenCount']+1});

      }
    }
  }


  Future<void> _checkImageOpenStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final imageRef = _firestore.collection("users").doc(fullUserId());
      final documentSnapshot = await imageRef.get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data['lastOpenAdTime']==null) {
          _loadRewardedAd();
        } else {
          final lastOpenTime = data['lastOpenAdTime'] as Timestamp;
          final currentTime = Timestamp.now();
          final difference = currentTime.seconds - lastOpenTime.seconds;
          if(difference >= 10800){
            _loadRewardedAd();
          }else{
            remainingTime = ((10800 - difference) / 60)/60;
            showToastText("${remainingTime.toStringAsFixed(1)} Hours for Ad" );
          }
        }
      }
    }
  }
  List<ProjectConvertor> projects = [];

  @override
  void initState() {
    super.initState();
    _checkImageOpenStatus();
    getDat(false);
  }

  Future<dynamic> getDat(bool isReload) async {
    projects = await getBranchStudyMaterials(isReload);
    setState(() {
      projects;
    });
  }

  Future<dynamic> getData() async {
    await getDat(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: RefreshIndicator(
        onRefresh: getData,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBar_HomePage(
                  size: 1,
                  name: "",
                  projects: projects,
                ),
                StreamBuilder<List<HomePageImagesConvertor>>(
                  stream: readHomePageImagesConvertor(),
                  builder: (context, snapshot) {
                    final subjects = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 0.3,
                            color: Colors.cyan,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Text("Error with server");
                        } else {
                          return subjects!.isNotEmpty
                              ? HomePageMenuBar(data: subjects.toList())
                              : Container();
                        }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Projects Categories",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabBatList.length,
                    itemBuilder: (context, index) {
                      List<String> images = [
                        "assets/uno.png",
                        "assets/raspi.png",
                        "assets/electronics.png",
                        "assets/sensors.png"
                      ];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 25 : 8,
                          right: index == tabBatList.length - 1 ? 20 : 0,
                        ),
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  width: 100,
                                  color: Colors.black12,
                                  child: Image.asset(images[index]),
                                ),
                              ),
                              Text(
                                tabBatList[index],
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (index == 3 || index == 1) {
                              showToastText("Coming Soon");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => projectsBasedOnType(
                                    projects: projects,
                                    type: tabBatList[index],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "All Videos",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = projects[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Project(data: data),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 8,
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(data.Images.main),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.black12,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white24),
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        topLeft: Radius.circular(15),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    child: Text(
                                      data.type,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "${data.heading.full}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: projects.length,
                ),
              ],
            ),
          ),
        ),
      ),
    )
    ;
  }
}

class ProjectsConvertor {
  String id;
  final String heading, images, time, VL, type;

  ProjectsConvertor({
    this.id = "",
    required this.heading,
    required this.images,
    required this.time,
    required this.type,
    required this.VL,
  });

  static ProjectsConvertor fromJson(Map<String, dynamic> json) =>
      ProjectsConvertor(
          id: json['id'],
          heading: json["title"],
          type: json["type"] ?? "",
          time: json["time"],
          images: json["Thumbnails"],
          VL: json["ViewsLikes"]);
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

class HomePageMenuBar extends StatefulWidget {
  final List<HomePageImagesConvertor> data;

  const HomePageMenuBar({super.key, required this.data});

  @override
  _HomePageMenuBarState createState() => _HomePageMenuBarState();
}

class _HomePageMenuBarState extends State<HomePageMenuBar> {
  int imageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        imageIndex = (imageIndex + 1) % widget.data.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.network(
            "${widget.data[imageIndex].image}",
            fit: BoxFit.fill,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.data.asMap().entries.map((entry) {
            int index = entry.key;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1),
              child: Container(
                height: 6,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: imageIndex == index ? Colors.black : Colors.black54,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

String getID() {
  var now = DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}

Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18, timeInSecForIosWeb: 5);
}

class appBar_HomePage extends StatefulWidget {
  double size;
  String name;
  List<ProjectConvertor> projects;

  appBar_HomePage(
      {required this.size, required this.projects, required this.name});

  @override
  State<appBar_HomePage> createState() => _appBar_HomePageState();
}

class _appBar_HomePageState extends State<appBar_HomePage> {
  List searchList = [
    "Search About",
    "Boards",
    "Projects",
    "Arduino",
    "Esp8266 & Esp32"
  ];
  List notificationsList = [
    "Notifications",
  ];
  bool _isVisible = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.size * 10.0, vertical: widget.size * 5),
              child: _isVisible
                  ? TweenAnimationBuilder(
                      tween: Tween<double>(
                          begin: 0.0, end: _isVisible ? 1.0 : 0.0),
                      duration: Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value as double,
                          child: InkWell(
                            onTap: () {
                              ExternalLaunchUrl(
                                  "https://www.youtube.com/@NSIdeas");
                              // changeTab(2);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Size * 10),
                              child: Text(
                                "NS Ideas",
                                style: TextStyle(
                                  fontSize: widget.size * 22.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: widget.size * 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$greeting',
                            style: TextStyle(
                                fontSize: widget.size * 14.0,
                                color: Colors.black54),
                          ),
                          Text(
                            "${widget.name.toUpperCase()}",
                            style: TextStyle(
                              fontSize: widget.size * 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => settings()));
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.settings,
                      size: 25,
                    )))
          ],
        ),
        InkWell(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => searchBar(
                          projects: widget.projects,
                        )));
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(Size * 25),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 15,
                            vertical: widget.size * 2),
                        child: Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: widget.size * 25,
                        ),
                      ),
                      Expanded(
                        child: CarouselSlider(
                          items: List.generate(
                            searchList.length,
                            (int index) {
                              return Row(
                                children: [
                                  Text(
                                    searchList[index],
                                    style: TextStyle(
                                        fontSize: widget.size * 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            },
                          ),
                          //Slider Container properties
                          options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            // Set the axis to vertical
                            viewportFraction: 0.95,
                            disableCenter: true,
                            enlargeCenterPage: true,
                            height: widget.size * 40,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 3),
                            autoPlay: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      showToastText("Coming Soon");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(Size * 20),
                      ),
                      child: CarouselSlider(
                        items: List.generate(
                          notificationsList.length,
                          (int index) {
                            return Center(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      notificationsList[index],
                                      style: TextStyle(
                                          fontSize: widget.size * 13.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ]),
                            );
                          },
                        ),
                        //Slider Container properties
                        options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 0.95,
                          disableCenter: true,
                          enlargeCenterPage: true,
                          height: widget.size * 25,
                          autoPlayAnimationDuration: const Duration(seconds: 3),
                          autoPlay: true,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}
