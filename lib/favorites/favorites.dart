import 'package:flutter/material.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/project_files/converter.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/test.dart';

import '../ads/ads.dart';
import '../home_page/home_page.dart';
import '../shopping/Converter.dart';
import '../shopping/sub_page.dart';
import 'converter.dart';

class favorites extends StatefulWidget {
  const favorites({super.key});

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  List<ProductsConverter> products = [];
  List<ProjectConverter> projects = [];

  getData() async {
    products = await SavedProductsPreferences.get();
    projects = await SavedProjectsPreferences.get();

    setState(() {
      products;
      projects;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            HeadingH1(heading: "Favorites"),
            if(products.isNotEmpty)Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, int index) {
                  final data = products[index];
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
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                              aspectRatio: 16 / 6,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data.images.first,
                                    fit: BoxFit.cover,
                                  ))),
                          Text(
                            data.heading,
                            style: TextStyle(fontSize: 22),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  "₹ ${data.cost - data.cost * (data.discount / 100)}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    " ${data.discount}%",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ),
                                ),
                                Text(
                                  "₹ ${data.cost}",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () async {
                                      await SavedProductsPreferences.delete(
                                          data.id);
                                      getData();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "Remove",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        )))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            if(projects.isNotEmpty)Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Projects",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, int index) {
                  final data = projects[index];
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
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                              aspectRatio: 16 / 6,
                              child: ImageShowAndDownload(image: data.thumbnail.fileUrl,id: "project",)),
                          Text(
                            data.heading.full,
                            style: TextStyle(fontSize: 22,color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    await SavedProjectsPreferences.delete(
                                        data.id);
                                    getData();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
            if(products.isEmpty&&projects.isEmpty)Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text("Empty",style: TextStyle(fontSize: 20,color: Colors.white70),),
            ))
          ],
        ),
      ),
    );
  }
}
