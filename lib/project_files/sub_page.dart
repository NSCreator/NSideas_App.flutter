import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (widget.data.images.isNotEmpty)scrollingImages(
                      images: widget.data.images
                          .map((HomePageImage) => HomePageImage.file_url)
                          .toList(),
                      id: "HomePageImages",
                      isZoom: true,
                      ar: AspectRatio(
                        aspectRatio: 16 / 9,
                      )),

                  if (widget.data.heading.full.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        widget.data.heading.full,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
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
                                    border: Border.all(color: Colors.black26)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
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
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (ids.contains(widget.data.id))
                            await SavedProjectsPreferences.delete(
                                widget.data.id);
                          else
                            await SavedProjectsPreferences.add(widget.data);
                          getData();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              Icon(
                                ids.contains(widget.data.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.data.about.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HeadingWithDivider(
                              heading: "About",
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
              if (widget.data.tableOfContent.isNotEmpty)
                tableOfContent(
                  list: widget.data.tableOfContent,
                ),
              if (widget.data.componentsAndSupplies.isNotEmpty)
                Requires(
                  data: widget.data.componentsAndSupplies,
                  title: "Components And Supplies",
                ),
              Description(
                id: widget.data.id,
                data: widget.data.description, mode: 'projects',
              ),
              if (widget.data.toolsRequired.isNotEmpty)
                Requires(
                    data: widget.data.toolsRequired, title: "Tools Required"),
              if (widget.data.appAndPlatforms.isNotEmpty)
                Requires(
                    data: widget.data.appAndPlatforms,
                    title: "Apps and Platforms"),
              if (widget.data.youtubeUrl.isNotEmpty)
                youtubeInfo(
                  url: widget.data.youtubeUrl,
                ),
              // CommentsWidgets()
            ],
          ),
        ),
      ),
    );
  }
}
