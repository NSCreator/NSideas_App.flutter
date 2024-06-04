import 'package:flutter/material.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/sub_page.dart';

import '../ads/ads.dart';
import '../functions.dart';
import '../home_page/home_page.dart';
import '../shopping/shopping_page.dart';


class Projects extends StatefulWidget {
  List<ProjectConverter> projects;
  Projects({required this.projects});
  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text("Projects", style: HeadingTextStyle),
            ),

            widget.projects.isNotEmpty?ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {
                  final data = widget.projects[index];
                  bool _isTapped = false;
                  return InkWell(
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

                        // Reset the flag after 2-3 seconds
                        Future.delayed(Duration(seconds: 2), () {
                          _isTapped = false;
                        });
                      }
                    },
                    child: projectShowingContainer(data: data,),
                  );

                },
                itemCount: widget.projects.length): Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(

                  children: [
                    Icon(Icons.smart_toy_outlined,color: Colors.black,size: 50,),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
