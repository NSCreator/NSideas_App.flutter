// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nsideas/projects.dart';

import 'functions.dart';
import 'homePage.dart';

class projectsBasedOnType extends StatefulWidget {
  List<ProjectConvertor> projects;
  String type;

  projectsBasedOnType({required this.projects, required this.type});

  @override
  State<projectsBasedOnType> createState() => _projectsBasedOnTypeState();
}

class _projectsBasedOnTypeState extends State<projectsBasedOnType> {
  List<ProjectConvertor> projects = [];

  void filterData() {
    for (ProjectConvertor data in widget.projects) {
      if (widget.type.contains("&") ?
      (data.type.startsWith(widget.type.split("&")[0].trimRight()) ||
          data.type.startsWith(widget.type.split("&")[1].trim())) :
      (data.type.toUpperCase().startsWith(widget.type.toUpperCase().trimRight()))
      ) {
        projects.add(data);
      }
    }
    setState(() => projects);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                      Text(
                        " ${widget.type} Projects",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              projects.isNotEmpty?ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index) {
                    final data = projects[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Project(data: data)));
                      },
                      child: projectShowingContainer(data: data,),
                    );

                  },
                  itemCount: projects.length): Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(

                                      children: [
                      Icon(Icons.smart_toy_outlined,color: Colors.black,size: 50,),
                                        Text("No ${widget.type} Projects")
                                      ],
                                    ),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

class Project extends StatefulWidget {
  ProjectConvertor data;

  Project({required this.data});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),

                  Padding(
                    padding: EdgeInsets.all( 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.data.Images.main.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: scrollingImages(
                              images: [widget.data.Images.main],
                              id: widget.data.id,
                              isZoom: true,
                            ),
                          ),
                        if(widget.data.heading.full.isNotEmpty)Padding(
                          padding: EdgeInsets.all( 8.0),
                          child: Text(
                            widget.data.heading.full,
                            style: TextStyle(
                                fontSize:18, color: Colors.black),
                          ),
                        ),
                        if(widget.data.tags.isNotEmpty)Wrap(
                          direction: Axis.horizontal,
                          children: widget.data.tags
                              .map(
                                (text) => Padding(
                                  padding: EdgeInsets.only(
                                      left:5 , bottom:  5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3,
                                        horizontal: 8),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        if(widget.data.about.isNotEmpty)Padding(
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
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        height:  1,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    Text(
                                      "About",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black,fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        height:  1,
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      left:10,
                                      right: 10,
                                      bottom:15,
                                      top: 3),
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
                  if(widget.data.tableOfContent.isNotEmpty)tableOfContent(
                    list: widget.data.tableOfContent,
                  ),
                  if(widget.data.ComponentsAndSupplies.isNotEmpty)Requires(data: widget.data.ComponentsAndSupplies,title: "Components And Supplies",),

                  Description(
                    id: widget.data.id,
                    data: widget.data.description,
                  ),
                  if(widget.data.toolsRequired.isNotEmpty)Requires(data: widget.data.toolsRequired,title: "Tools Required"),
                  if(widget.data.appAndPlatforms.isNotEmpty)Requires(data: widget.data.appAndPlatforms,title: "Apps and Platforms"),

                  if(widget.data.youtubeLink.isNotEmpty)youtubeInfo(
                    url: widget.data.youtubeLink,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 8, right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueGrey.withOpacity(1),
                      Colors.blueGrey.withOpacity(1),
                      Colors.blueGrey.withOpacity(0.8),
                      Colors.blueGrey.withOpacity(0.7),
                      Colors.blueGrey.withOpacity(0.6),
                      Colors.blueGrey.withOpacity(0.2),
                      Colors.white.withOpacity(0.01)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            " ${widget.data.heading.short}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
