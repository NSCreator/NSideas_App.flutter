import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nsideas/Description/description.dart';
import 'package:nsideas/test.dart';

import '../functions.dart';
import 'projects_test.dart';
import '../sensors/sub_page.dart';
import 'converter.dart';

class Project extends StatefulWidget {
  ProjectConverter data;

  Project({required this.data});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  List<String> ids = [];

  getData() async {
    List<ProjectConverter> subjects = await SavedProjectsPreferences.get();
    ids = subjects.map((x) => x.id).toList();
    setState(() {
      ids;
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              if (widget.data.heading.short.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: HeadingH2(heading:widget.data.heading.short),
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
                          icon: Icon(Icons.edit)),
                    InkWell(
                      onTap: () async {
                        if (ids.contains(widget.data.id))
                          await SavedProjectsPreferences.delete(widget.data.id);
                        else
                          await SavedProjectsPreferences.add(widget.data);
                        getData();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 10, left: 5,bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(
                              ids.contains(widget.data.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 25,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ImageShowAndDownload(
                  image: widget.data.thumbnail.fileUrl, id: "projects"),

              if (widget.data.heading.full.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.data.heading.full,
                    style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.w500),
                  ),
                ),
              if (widget.data.tags.isNotEmpty)
                Wrap(
                  direction: Axis.horizontal,
                  children: widget.data.tags
                      .map(
                        (text) => Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white30)),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 8),
                            child: Text(
                              text,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (widget.data.images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: scrollingImages(
                      images: widget.data.images
                          .map((HomePageImage) => HomePageImage.fileUrl)
                          .toList(),
                      id: widget.data.type,
                      isZoom: true,
                      ar: AspectRatio(
                        aspectRatio: 16 / 6,
                      )),
                ),
              if( widget.data.youtubeData.isNotEmpty)Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    HeadingWithDivider(
                        heading:
                            "Youtube Video${widget.data.youtubeData.length > 1 ? "s" : ""}"),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data.youtubeData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          final youtubeData = widget.data.youtubeData[index];
                          return InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return youtube(
                                    url: youtubeData.video_url,
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                 ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.data.thumbnail.fileUrl.isNotEmpty)
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ImageShowAndDownload(
                                          image: widget.data.thumbnail.fileUrl,
                                          id: "projects",
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (youtubeData.heading.isNotEmpty)
                                            Text(
                                              youtubeData.heading,
                                              style: TextStyle(fontSize: 18,color: Colors.white),
                                            ),
                                          if (youtubeData.note.isNotEmpty)
                                            Text(
                                              youtubeData.note,
                                              style: TextStyle(fontSize: 12,color: Colors.white70),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              if (widget.data.about.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: HeadingWithDivider(
                        heading: "About",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 20, top: 5),
                      child: StyledTextWidget(
                        text: '${widget.data.about}',
                      ),
                    ),
                  ],
                ),
              if (widget.data.tableOfContent.isNotEmpty)
                tableOfContent(
                  list: widget.data.tableOfContent,
                ),

              Description(
                id: widget.data.id,
                data: widget.data.description,
                mode: 'projects',
              ),
              if (widget.data.componentsAndSupplies.isNotEmpty)
                ConvertorForTRCSRC_Container(
                  data: widget.data.componentsAndSupplies,
                  title: "Components And Supplies",
                ),
              if (widget.data.toolsRequired.isNotEmpty)
                ConvertorForTRCSRC_Container(
                    data: widget.data.toolsRequired, title: "Tools Required"),
              if (widget.data.appAndPlatforms.isNotEmpty)
                ConvertorForTRCSRC_Container(
                    data: widget.data.appAndPlatforms,
                    title: "Apps and Platforms"),
              SizedBox(
                height: 150,
              )
              // CommentsWidgets()
            ],
          ),
        ),
      ),
    );
  }
}
