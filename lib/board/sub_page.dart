import 'package:flutter/material.dart';
import 'package:nsideas/sensors/sub_page.dart';

import '../Description/description.dart';
import '../functions.dart';
import '../home_page/home_page.dart';
import '../test.dart';
import 'converter.dart';
import 'creator.dart';

class Board extends StatefulWidget {
  BoardsConverter data;

  Board({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    backButton(),
                    if (isOwner())
                      PopupMenuButton<String>(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (String value) {
                          if (value == 'edit') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardCreator(
                                      data: widget.data,
                                    )));
                          } else if (value == 'delete') {
                            showToastText('Delete action selected');
                          }
                        },
                      ),
                  ],
                ),
                HeadingH2(heading:widget.data.heading.short),
                if(widget.data.thumbnail.fileUrl.isNotEmpty)ImageShowAndDownload(image: widget.data.thumbnail.fileUrl, id: "board"),
                if (widget.data.heading.full.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.data.heading.full,
                      style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.w500),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.data.images.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: scrollingImages(
                            images: widget.data.images.map((e) => e.fileUrl).toList(),
                            id: widget.data.id,
                            isZoom: true,
                            ar: AspectRatio(aspectRatio: 16/6),
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
                                HeadingWithDivider(heading: "About"),

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
                  data: widget.data.descriptions, mode: 'boards',
                ),
                if (widget.data.pinDiagram.fileUrl.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                    child: Text(
                      "Pin Connection",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                if (widget.data.pinDiagram.fileUrl.isNotEmpty)ImageShowAndDownload(
                  image: widget.data.pinDiagram.fileUrl,
                  id: widget.data.id,
                  isZoom: true,
                ),
                Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "---${widget.data.heading.full}---",
                        style: TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
