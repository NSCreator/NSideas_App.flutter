// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nsideas/projects.dart';
import 'package:nsideas/settings.dart';
import 'package:nsideas/textFeild.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'authPage.dart';
import 'homePage.dart';


const TextStyle creatorHeadingTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black);

class backGroundImage extends StatefulWidget {
  Widget child;
  String text;

  backGroundImage({super.key, required this.child, this.text = ""});

  @override
  State<backGroundImage> createState() => _backGroundImageState();
}

class _backGroundImageState extends State<backGroundImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: widget.child,
            )),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 30, left: 8, right: 8),
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
                            " ${widget.text}",
                            style: TextStyle(color: Colors.black87, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatefulWidget {
  Widget child;
  String heading;

  TextFieldContainer({super.key, required this.child, this.heading = ""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              widget.heading,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),

        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              // border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

TextStyle textFieldStyle(double size) {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: size * 20,
  );
}

TextStyle textFieldHintStyle(double size) {
  return TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w300,
    fontSize: size * 18,
  );
}

class ImageShowAndDownload extends StatefulWidget {
  String id, image;
  bool isZoom;

  ImageShowAndDownload(
      {super.key, required this.image, required this.id, this.isZoom = false});

  @override
  State<ImageShowAndDownload> createState() => _ImageShowAndDownloadState();
}

class _ImageShowAndDownloadState extends State<ImageShowAndDownload> {
  String filePath = "";

  @override
  void initState() {
    super.initState();
    getPath();
  }

  getPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    filePath =
        '${appDir.path}/${widget.id}/${Uri.parse(widget.image).pathSegments.last}';
    if (!File(filePath).existsSync()) {
      await _downloadImages(widget.image);
    }
    setState(() {
      filePath;
    });
  }

  _downloadImages(String url) async {
    String name;
    final Uri uri = Uri.parse(url);
    if (url.startsWith('https://drive.google.com')) {
      name = url.split(";").first.split('/d/')[1].split('/')[0];
      url = "https://drive.google.com/uc?export=download&id=$name";
    } else {
      name = uri.pathSegments.last.split("/").last;
    }
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/${widget.id}');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/$name');
    await file.writeAsBytes(response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isZoom
        ? InkWell(
            child: !File(filePath).existsSync()
                ? SizedBox(
              width: double.infinity,
              child: Image.network(widget.image,fit: BoxFit.cover,),
            )
                : SizedBox(
              width: double.infinity,
                  child: Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                    ),
                ),
            onTap: () {
              if (widget.isZoom)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                            backgroundColor: Colors.black,
                            body: SafeArea(
                              child: Column(
                                children: [
                                  backButton(
                                    text: "back",
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: File(filePath).existsSync()
                                          ? PhotoView(
                                              imageProvider:
                                                  FileImage(File(filePath)))
                                          : PhotoView(
                                              imageProvider:
                                                  NetworkImage(widget.image),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ))));
            },
          )
        : !File(filePath).existsSync()
            ? SizedBox(
      width: double.infinity,
                child: Image.network(widget.image,fit: BoxFit.cover,),
              )
            : SizedBox(
      width: double.infinity,
              child: Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                ),
            );
  }
}

class backButton extends StatefulWidget {
  String text;

  backButton({super.key, this.text = ""});

  @override
  State<backButton> createState() => _backButtonState();
}

class _backButtonState extends State<backButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.white,
              ),
            ),
            if (widget.text.isNotEmpty)
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class scrollingImages extends StatefulWidget {
  final List images;
  final String id;
  bool isZoom;

  scrollingImages(
      {Key? key, required this.images, required this.id, this.isZoom = false})
      : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath = '';
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: widget.images.length > 1 ? true : false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(Size * 10),
                  child: ImageShowAndDownload(
                    image: widget.images[itemIndex],
                    id: widget.id,
                    isZoom: widget.isZoom,
                  ));
            }),
        if (widget.images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.map((url) {
              int index = widget.images.indexOf(url);
              return Container(
                width: 5.0,
                height: 5.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? Colors.white
                      : const Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class tableOfContent extends StatefulWidget {
  final List list;

  const tableOfContent({Key? key, required this.list}) : super(key: key);

  @override
  State<tableOfContent> createState() => _tableOfContentState();
}

class _tableOfContentState extends State<tableOfContent> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
      margin: EdgeInsets.all(Size * 10.0),
      padding: EdgeInsets.all(Size * 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Size * 20),
          border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Table of Content : ",
            style: TextStyle(
                fontSize: Size * 20,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: EdgeInsets.only(left: Size * 20, right: Size * 10),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.list.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                String name = widget.list[index];
                return Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.circle,
                          size: Size * 5,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Size * 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: Size * 16,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Requires extends StatefulWidget {
  List<convertorForTRCSRC> data;
  String title;

  Requires({required this.data,required this.title});

  @override
  State<Requires> createState() => _RequiresState();
}

class _RequiresState extends State<Requires> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
      margin: EdgeInsets.all(Size * 10.0),
      padding: EdgeInsets.all(Size * 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Size * 20),
          border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: Size * 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          ListView.builder(
            padding: EdgeInsets.only(
                left: Size * 20, right: Size * 10),
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final data = widget.data[index];
              return Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Size * 5,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Size * 5,
                  ),
                  Expanded(
                    child: InkWell(
                      child: Text(
                        data.heading,
                        style: TextStyle(
                          fontSize: Size * 18,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => zoom(
                                    url: data.image)));
                      },
                    ),
                  ),
                  InkWell(
                    child: Icon(
                      Icons.open_in_new,
                      color: Colors.lightGreenAccent,
                    ),
                    onTap: () {
                      ExternalLaunchUrl(data.link);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}




class youtube extends StatefulWidget {
  final url;

  const youtube({Key? key, required this.url}) : super(key: key);

  @override
  State<youtube> createState() => _youtubeState();
}

class _youtubeState extends State<youtube> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () => debugPrint("Ready"),
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: const ProgressBarColors(
              playedColor: Colors.amber, handleColor: Colors.amberAccent),
        ),
        const PlaybackSpeedButton(),
        FullScreenButton()
      ],
    );
  }
}

class zoom extends StatefulWidget {
  String url;


  zoom({Key? key, required this.url})
      : super(key: key);

  @override
  State<zoom> createState() => _zoomState();
}

class _zoomState extends State<zoom> {


  @override
  Widget build(BuildContext context) {
    return backGroundImage(
      text: "back",
      child: Center(
        child: PhotoView(
                imageProvider: NetworkImage(widget.url),
              ),
      ),
    );
  }
}

class Description extends StatefulWidget {
  final List<DescriptionConvertor> data;
  final String id;

  Description({required this.id, required this.data});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.08)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Size * 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Project Description",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: Size * 20),
                ),
                if(isUser())ElevatedButton(
                  child: Text("ADD"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionCreator(
                                  id: widget.id,
                                )));
                  },
                ),
              ],
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final SubjectsData = widget.data[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (SubjectsData.subData.isNotEmpty)
                        StyledTextWidget(
                          text: SubjectsData.data,
                          fontSize: Size * 18,
                          color: Colors.black,
                        )
                      else if (SubjectsData.images.isNotEmpty)
                        StyledTextWidget(
                          text: SubjectsData.data,
                          fontSize: Size * 18,
                          color: Colors.black87,
                        )
                      else
                        StyledTextWidget(
                            text: "       ${SubjectsData.data}",
                            fontSize: Size * 18,
                            color: Colors.black.withOpacity(0.9)),
                      if (SubjectsData.images.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: Size * 20),
                          child: scrollingImages(
                            images: SubjectsData.images,
                            id: widget.id,
                            isZoom: true,
                          ),
                        ),
                      if (SubjectsData.subData.isNotEmpty)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: SubjectsData.subData.length,
                            itemBuilder: (BuildContext context, int index) {

                              if (SubjectsData.subData.isNotEmpty) {
                                return Padding(
                                  padding: EdgeInsets.all(Size * 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${index + 1}. ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: Size * 14),
                                      ),
                                      Expanded(
                                          child: StyledTextWidget(
                                              text: SubjectsData.subData[index],
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: Size * 16)),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                    padding: EdgeInsets.all(Size * 5.0),
                                    child: StyledTextWidget(
                                        text: SubjectsData.subData[index],
                                        color: Colors.amberAccent,
                                        fontSize: Size * 20));
                              }
                            }),
                    ],
                  ),
                  if (SubjectsData.table.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Size * 8, vertical: Size * 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: SubjectsData.table
                              .length, // Number of rows including the header
                          itemBuilder: (context, index) {
                            TableConvertor subTechnicalParameters =
                                SubjectsData.table[index];
                            return Table(

                              border: TableBorder.all(
                                  width: Size * 0.5,
                                  color: Colors.white60,
                                  borderRadius: index ==0? BorderRadius.only(
                                      topLeft: Radius.circular(Size * 15),
                                      topRight: Radius.circular(Size * 15)): index ==
                                      SubjectsData.table.length - 1
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(Size * 15),
                                      bottomRight: Radius.circular(Size * 15)):BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FractionColumnWidth(0.2),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(Size * 8.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          subTechnicalParameters.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(Size * 8.0),
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters.description,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  if (SubjectsData.files.isNotEmpty)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: Container(
                        margin: EdgeInsets.all(Size * 5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          // border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(Size * 10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Size * 10),
                                  topLeft: Radius.circular(Size * 10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Size * 2.0,
                                    horizontal: Size * 6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Code",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.8, horizontal: 8),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "full code",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Scaffold(
                                                      backgroundColor: Colors.black,
                                                      body: SafeArea(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons.arrow_back,
                                                                      size: 25,
                                                                      color: Colors.white,
                                                                    ),
                                                                    Text(
                                                                      "back",
                                                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: SelectableText(
                                                                    SubjectsData.files.first,
                                                                    style: TextStyle(fontSize: Size * 16, color: Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )

                                            ));
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      SubjectsData.files.first,
                                      style: TextStyle(
                                          fontSize: Size * 16,
                                          color: Colors.white
                                              .withOpacity(0.9)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: Size * 15,
            ),
          ),
        ],
      ),
    );
  }
}

class youtubeInfo extends StatefulWidget {
  String url;

  youtubeInfo({required this.url});

  @override
  State<youtubeInfo> createState() => _youtubeInfoState();
}

class _youtubeInfoState extends State<youtubeInfo> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Size * 25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Making Video",
                style: TextStyle(
                    fontSize: Size * 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(Size * 20)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Size * 5.0, horizontal: 15),
                      child: Text(
                        "Play",
                        style:
                            TextStyle(color: Colors.white, fontSize: Size * 20),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return youtube(
                          url: widget.url,
                        );
                      },
                    );
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Size * 2.0, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(Size * 25)),
                    child: Row(
                      children: [
                        Text(
                          " View On ",
                          style: TextStyle(
                              color: Colors.white, fontSize: Size * 20),
                        ),
                        Container(
                            height: Size * 40,
                            width: Size * 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "https://ghiencongnghe.info/wp-content/uploads/2021/02/bia-youtube-la-gi.gif"))))
                      ],
                    ),
                  ),
                  onTap: () {
                    ExternalLaunchUrl(widget.url);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class StyledTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const StyledTextWidget(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    List<String> words = text.split(' ');

    for (String word in words) {
      if (word.startsWith('**')) {
        spans.add(TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.white54)),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  word.substring(2),
                  style: TextStyle(color: Colors.black, fontSize: fontSize - 5),
                ),
              ),
            ),
            TextSpan(text: ' '),
          ],
        ));
      } else if (word.startsWith("'") && word.endsWith("'")) {
        spans.add(TextSpan(
          text: '${word.substring(1, word.length - 1)} ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        spans.add(TextSpan(text: '$word '));
      }
    }

    return Wrap(
      children: [
        RichText(
          text: TextSpan(
              children: spans,
              style: TextStyle(
                  fontSize: fontSize, color: color, fontWeight: fontWeight)),
        ),
      ],
    );
  }
}
