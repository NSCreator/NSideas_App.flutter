// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:nsideas/projects.dart';
import 'package:nsideas/searchBar.dart';
import 'package:nsideas/settings.dart';
import 'package:nsideas/subPage.dart';
import 'package:nsideas/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'functions.dart';


class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/9491925792';
    } else {
      return 'ca-app-pub-7097300908994281/8849115979';
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _HomePageKey = GlobalKey<ScaffoldState>();

  List tabBatList = [
    "Arduino",
    "ESP",
    "Electronics",
    "Sensors",
  ];
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
  late final RewardedAd rewardedAd;
  bool isAdLoaded = false;

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
          showToastText("Ad loaded");
          rewardedAd = ad;
          _setFullScreenContentCallback();
          await _showRewardedAd();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('lastOpenAdTime', DateTime.now().millisecondsSinceEpoch);
        },
      ),
    );
  }
  //method to set show content call back
  void _setFullScreenContentCallback() {
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
  }

  double remainingTime = 0;


  Future<void> _checkImageOpenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? lastOpenTime = prefs.getInt('lastOpenAdTime');

    if (lastOpenTime == null) {
      _loadRewardedAd();
    } else {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = (currentTime - lastOpenTime) ~/ 1000;

      if (difference >= 43200) {
        _loadRewardedAd();
      } else {
        remainingTime = ((43200 - difference) / 60)/60;
        showToastText("Ad with in ${remainingTime.toInt()} Hours");
      }
    }
  }
  List<ProjectConvertor> projects = [];
  List<BoardsConvertor> boards = [];
  List<SensorsConverter> sensors = [];

  @override
  void initState() {
    super.initState();
     _checkImageOpenStatus();
    getDat(true);
  }

  Future<dynamic> getDat(bool isReload) async {
    projects = await getBranchStudyMaterials(isReload);
    boards = await getBoards(isReload);
    sensors = await getSensors(isReload);
    setState(() {
      projects;
      boards;
      sensors;
    });
  }

  Future<dynamic> getData() async {
    await getDat(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _HomePageKey,
      body: RefreshIndicator(
        onRefresh: getData,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: Icon(
                          Icons.menu,
                          size: 30,
                        ),
                        onTap: () {
                          _HomePageKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ExternalLaunchUrl("https://www.youtube.com/@NSIdeas");
                        // changeTab(2);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "NS Ideas",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => searchBar(
                                  projects: projects,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),

                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black45,
                                  size: 25,
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
                                                fontSize: 18.0,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400),
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
                                    height: 40,
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
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: CarouselSlider(
                                items: List.generate(
                                  notificationsList.length,
                                  (int index) {
                                    return Center(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              notificationsList[index],
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
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
                                  height: 25,
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 3),
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
                          return subjects != null && subjects.isNotEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: scrollingImages(
                                                            images:  subjects.map((subject) => subject.image).toList(),
                                                            id: "HomePageImages",
                                                            isZoom: true,
                                  ar: AspectRatio( aspectRatio: 16/5,)
                                                          ),
                              )
                              : Container();
                        }
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0,top: 25,bottom: 15),
                  child: Text(
                    "Projects Categories",
                    style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tabBatList.length,
                  itemBuilder: (context, index) {
                    List<String> images = [
                      "assets/uno.png",
                      "assets/esp.png",
                      "assets/electronics.png",
                      "assets/sensors.png"
                    ];
                    return InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 80,
                            margin: EdgeInsets.only(left: 20,bottom: 2,top: 2,right: 10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                              image: DecorationImage(image: AssetImage(images[index])),
                              borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                          Text(
                            tabBatList[index],
                            style: TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => sensorsAndComponents(sensors:sensors,),
                            ),
                          );
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
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10.0,top: 25),
                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
                  decoration: BoxDecoration(color: Color.fromRGBO(3, 24, 46,1),borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Videos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListView.separated(
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
                      child: Padding(
                        padding:  EdgeInsets.only(bottom:(index==projects.length-1)? 30:0,top: (index==0)?20:0),
                        child: projectShowingContainer(
                          data: data,
                        ),
                      ),
                    );
                  },
                  itemCount: projects.length, separatorBuilder: (BuildContext context, int index) { return Divider(height: 8,thickness: 1,color: Colors.black.withOpacity(0.1),); },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerBuilder(context),
    );
  }
  Widget DrawerBuilder(BuildContext context) {
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
    return Container(
      margin: EdgeInsets.only(right: 90),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0,top: 5),
              child: Text(
                '$greeting,',
                style: TextStyle(
                    fontSize: 18.0),
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
                  "Guest",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => settings()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.settings,
                        size: 30,
                      ),
                    )),
              ],
            ),
            // SizedBox(height: 20,),
            // DrawerTabButtonsBuilder("Favorites"),
            // DrawerTabButtonsBuilder("Downloads"),
            // DrawerTabButtonsBuilder("Favorites"),
            // DrawerTabButtonsBuilder("Favorites"),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Boards",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            DrawerTabsBuilder(Icons.ac_unit,"Arduino"),
            DrawerTabsBuilder(Icons.ac_unit,"ESP"),
            DrawerTabsBuilder(Icons.ac_unit,"Raspberry Pi"),
  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Projects",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            DrawerTabsForProjectsBuilder(Icons.ac_unit,"Arduino"),
            DrawerTabsForProjectsBuilder(Icons.ac_unit,"ESP"),
            DrawerTabsForProjectsBuilder(Icons.ac_unit,"Electronics"),


            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Settings",
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Electronics",
            //         style: TextStyle(fontSize: 22),
            //       ),
            //       Text(
            //         "Arduino",
            //         style: TextStyle(fontSize: 22),
            //       ),
            //       Text(
            //         "ESP8266 & ESP32",
            //         style: TextStyle(fontSize: 22),
            //       ),
            //     ],
            //   ),
            // ),
            Spacer(),

          ],
        ),
      ),
    );
  }
  Widget DrawerTabsBuilder(icon,String heading){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Boards(data: boards, boardName: heading,)));
      },
      child: Row(
        children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.05)
          ),
          child: Icon(icon,size: 30,),
        ),
          Text(heading,style: TextStyle(fontSize: 20,fontWeight:FontWeight.w400),)
        ],
      ),
    );
  }
  Widget DrawerTabsForProjectsBuilder(icon,String heading){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>projectsBasedOnType(projects: projects, type: heading,)));
      },
      child: Row(
        children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.05)
          ),
          child: Icon(icon,size: 30,),
        ),
          Text(heading,style: TextStyle(fontSize: 20,fontWeight:FontWeight.w400),)
        ],
      ),
    );
  }
  Widget DrawerTabButtonsBuilder(String data){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.05)
      ),
      child: Text(data,style: TextStyle(fontSize: 22),),
    );
  }
}
class Boards extends StatefulWidget {
  String boardName;
  List<BoardsConvertor> data;
   Boards({required this.boardName,required this.data});

  @override
  State<Boards> createState() => _BoardsState();
}

class _BoardsState extends State<Boards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Boards (${widget.boardName})",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.data.length,
                    shrinkWrap: true,
                    itemBuilder:
                        (BuildContext context, int index) {
                      final SubjectsData = widget.data[index];

                      return SubjectsData.type==widget.boardName ?InkWell(
                        child: Container(
                          margin:
                          EdgeInsets.only(left: 15, right: 5, bottom: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius:
                            BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            children: [
                              if(SubjectsData.images
                                  .first.isNotEmpty)Container(
                                child: ImageShowAndDownload(
                                  image: SubjectsData.images
                                      .first,
                                  id: SubjectsData.id,
                                ),
                                height: 70,
                                width: 100,
                              ),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.08)),
                                    child: Text(
                                      SubjectsData.heading.full,
                                      style: TextStyle(
                                        fontSize: 20, ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(
                                  milliseconds: 300),
                              pageBuilder: (context,
                                  animation,
                                  secondaryAnimation) =>
                                  arduinoBoard(
                                    data: SubjectsData,
                                  ),
                              transitionsBuilder: (context,
                                  animation,
                                  secondaryAnimation,
                                  child) {
                                final fadeTransition =
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color: Colors.black
                                      .withOpacity(
                                      animation.value),
                                  child: AnimatedOpacity(
                                      duration: Duration(
                                          milliseconds: 300),
                                      opacity: animation.value
                                          .clamp(0.3, 1.0),
                                      child: fadeTransition),
                                );
                              },
                            ),
                          );
                        },
                      ):Container();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class projectShowingContainer extends StatefulWidget {
  ProjectConvertor data;

  projectShowingContainer({super.key, required this.data});

  @override
  State<projectShowingContainer> createState() =>
      _projectShowingContainerState();
}

class _projectShowingContainerState extends State<projectShowingContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${widget.data.heading.full}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.data.Images.main),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(

                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Text(
                  widget.data.type,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
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


String getID() {
  var now = DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}

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



class BoardsConvertor {
  String id;
  final HeadingConvertor heading;
  final String about,type;
  final List<String> images, pinDiagrams;
  final List<DescriptionConvertor> descriptions;

  BoardsConvertor({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.about,
    required this.pinDiagrams,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'heading': heading.toJson(),
        'images': images,
        'type': type,
        "descriptions": descriptions.map((unit) => unit.toJson()).toList(),
        'about': about,
        'pinDiagrams': pinDiagrams,
      };

  static BoardsConvertor fromJson(Map<String, dynamic> json) =>
      BoardsConvertor(
        id: json['id'],
        type: json['type'],
        descriptions:
            DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
        heading: HeadingConvertor.fromJson(json["heading"]),
        images: List<String>.from(json["images"]),
        about: json["about"],
        pinDiagrams: List<String>.from(json["pinDiagrams"]),
      );

  static List<BoardsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class arduinoBoard extends StatefulWidget {
  BoardsConvertor data;

  arduinoBoard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<arduinoBoard> createState() => _arduinoBoardState();
}

class _arduinoBoardState extends State<arduinoBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(
              text: widget.data.heading.short,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.data.images.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: scrollingImages(
                        images: widget.data.images,
                        id: widget.data.id,
                        isZoom: true,
                      ),
                    ),
                  if (widget.data.heading.full.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        widget.data.heading.full,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  if (widget.data.about.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 15, top: 3),
                              child: StyledTextWidget(
                                text: '${widget.data.about}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            Description(
              id: widget.data.id,
              data: widget.data.descriptions,
            ),
            if (widget.data.pinDiagrams.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                child: Text(
                  "PinOut",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            scrollingImages(
              images: widget.data.pinDiagrams,
              id: widget.data.id,
              isZoom: true,
            ),
            Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "---${widget.data.heading.full}---",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
