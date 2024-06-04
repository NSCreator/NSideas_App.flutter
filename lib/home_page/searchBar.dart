// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import '../ads/ads.dart';
import '../functions.dart';
import 'home_page.dart';

class searchBar extends StatefulWidget {
  List<ProjectConverter> projects;

  searchBar({required this.projects});

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          backButton(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.projects.length,
                itemBuilder: (context, int index) {
                  final data = widget.projects[index];
                  bool _isTapped = false;
                  return data.heading.short
                              .toLowerCase()
                              .contains(name.toLowerCase()) ||
                          data.heading.full
                              .toLowerCase()
                              .contains(name.toLowerCase()) ||
                          data.tags.contains(name.toUpperCase())
                      ? InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              children: [
                                if (data.images.isNotEmpty)
                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    height: 55,
                                    child: AspectRatio(
                                      aspectRatio: 16/9,
                                      child: ImageShowAndDownload(image:data.thumbnail.fileUrl ,id:"projects" ,),
                                    ),
                                  ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.heading.short,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      data.heading.full,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
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
                            showToastText("Error with Ad, Please Message Owner");
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
                        )
                      : Container();
                }),
          ),
        ],
      ),
    ));
  }
}
