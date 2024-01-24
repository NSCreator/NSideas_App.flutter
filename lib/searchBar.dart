// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nsideas/projects.dart';
import 'package:nsideas/subPage.dart';

import 'package:path_provider/path_provider.dart';

import 'functions.dart';

class searchBar extends StatefulWidget {
  List<ProjectConvertor> projects;

  searchBar({required this.projects});

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";
  String folderPath = "";
  File file = File("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
  }

  getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    folderPath = directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextFieldContainer(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right:  10),
                            child: Icon(
                              Icons.search,
                              size:  25,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize:  16),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Bar',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (name.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() {
                          name = "";
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right:  10,
                        ),
                        child: Icon(
                          Icons.clear,
                          size:  35,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.projects.length,
                    itemBuilder: (context, int index) {
                      final data = widget.projects[index];
                      return data.heading.short
                                  .toLowerCase()
                                  .contains(name.toLowerCase()) ||
                              data.heading.full
                                  .toLowerCase()
                                  .contains(name.toLowerCase()) ||
                              data.tags.contains(name.toUpperCase())
                          ? InkWell(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(27)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(data.Images.main),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.heading.short,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          data.heading.full,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Project(data:data)));

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
