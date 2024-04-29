// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/textFeild.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'ads/ads.dart';
import 'home_page/home_page.dart';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/home_page/home_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:http/http.dart' as http;


bool isAnonymousUser() => FirebaseAuth.instance.currentUser!.isAnonymous;

String getID() => DateFormat('kk:mm:ss-d.M.y').format(DateTime.now());

String userId() => FirebaseAuth.instance.currentUser!.email.toString();

isOwner() =>
    !isAnonymousUser() &&
    ((FirebaseAuth.instance.currentUser!.email! ==
            "sujithnimmala03@gmail.com") ||
        (FirebaseAuth.instance.currentUser!.email! ==
            "sujithnaidu03@gmail.com"));

class CommentsWidgets extends StatefulWidget {
  const CommentsWidgets({super.key});

  @override
  State<CommentsWidgets> createState() => _CommentsWidgetsState();
}

class _CommentsWidgetsState extends State<CommentsWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                child: Text(
                  "ere",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.05)),
                  child: Text("Comment Here"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

const TextStyle creatorHeadingTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black);

class TextFieldContainer extends StatelessWidget {
  Widget child;
  String heading;

  TextFieldContainer({super.key, required this.child, this.heading = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              heading,
              style: TextStyle(
                  fontSize: 15,

                  color: Colors.black),
            ),
          ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.white54),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withOpacity(0.15))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

TextStyle textFieldStyle() {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
}

TextStyle textFieldHintStyle() {
  return TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w300,
    fontSize: 18,
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final fileName = widget.image.split("/").last;

    filePath = '${appDir.path}/$fileName';

    if (await File(filePath).exists()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      await _download(widget.image);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _download(String fileUrl) async {
    try {
      var response;
      if (fileUrl.startsWith('https://drive.google.com')) {
        String name = fileUrl.split('/d/')[1].split('/')[0];
        fileUrl = "https://drive.google.com/uc?export=download&id=$name";
        response = await http.get(Uri.parse(fileUrl));
      } else {
        try {
          response = await http.get(Uri.parse(fileUrl));
        } catch (e) {
          fileUrl = await getFileUrl(fileUrl);
          response = await http.get(Uri.parse(fileUrl));
        }
      }
      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final newDirectory =
            Directory('${documentDirectory.path}/${widget.id}');
        if (!await newDirectory.exists()) {
          await newDirectory.create(recursive: true);
        }
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        print('Failed to download file. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Colors.greenAccent,
      ));
    } else {
      if (widget.isZoom) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  backgroundColor: Colors.black,
                  body: SafeArea(
                    child: Column(
                      children: [
                        backButton(),
                        Expanded(
                          child: Center(
                            child: Image.file(
                              File(filePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Image.file(
            File(filePath),
            fit: BoxFit.fill,
          ),
        );
      } else {
        return Image.file(
          File(filePath),
          fit: BoxFit.fill,
        );
      }
    }
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
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    "back ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class scrollingImages extends StatefulWidget {
  AspectRatio ar;
  final List images;
  final String id;
  bool isZoom;

  scrollingImages({
    Key? key,
    required this.images,
    required this.id,
    this.isZoom = false,
    this.ar = const AspectRatio(aspectRatio: 16 / 9),
  }) : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath = '';
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                aspectRatio: widget.ar.aspectRatio,
                viewportFraction: 1,
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
              return  ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: widget.ar.aspectRatio,
                  child: ImageShowAndDownload(
                    image: widget.images[itemIndex],
                    id: widget.id,
                    isZoom: widget.isZoom,
                  ),
                ),
              );
            }),
        Positioned(
          bottom: 5,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index ? Colors.white : Colors.white24,
                  ),
                );
              }).toList(),
            ),
          ),
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
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadingWithDivider(
            heading: "Table of Content",
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
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
                          size: 5,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
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
  List<ConvertorForTRCSRC> data;
  String title;

  Requires({required this.data, required this.title});

  @override
  State<Requires> createState() => _RequiresState();
}

class _RequiresState extends State<Requires> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadingWithDivider(
            heading: widget.title,
          ),
          ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 10),
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
                        size: 5,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: InkWell(
                      child: Text(
                        data.heading,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        if (data.IVF!=null)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => zoom(url: data.IVF.file_url)));
                        else {
                          showToastText("Image Not Found");
                        }
                      },
                    ),
                  ),
                  if (data.path!=null)
                    InkWell(
                      child: Icon(
                        Icons.open_in_new,
                        color: Colors.lightGreenAccent,
                      ),

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

  zoom({Key? key, required this.url}) : super(key: key);

  @override
  State<zoom> createState() => _zoomState();
}

class _zoomState extends State<zoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
  final String mode;

  Description({required this.id, required this.data, required this.mode});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOwner())
            Row(
              children: [
                ElevatedButton(
                  child: Text("ADD"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionCreator(
                                  id: widget.id,
                                  mode: widget.mode,
                                )));
                  },
                ),
              ],
            ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final data = widget.data[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (isOwner())
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DescriptionCreator(
                                        id: widget.id,
                                        mode: widget.mode,
                                        data: data,
                                      )));
                        },
                        icon: Icon(Icons.edit)),
                  if (data.points.isNotEmpty)
                    StyledTextWidget(
                      text: data.heading,
                      fontSize: 20,
                      color: Colors.black,
                    )
                  else if (data.IVF.isNotEmpty)
                    StyledTextWidget(
                      text: data.heading,
                      fontSize: 20,
                      color: Colors.black87,
                    )
                  else
                    StyledTextWidget(
                        text: data.heading,
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.9)),
                  if (data.IVF.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: scrollingImages(
                        images: data.IVF
                            .map((HomePageImage) => HomePageImage?.file_url)
                            .toList(),
                        id: widget.id,
                        isZoom: true,
                      ),
                    ),
                  if (data.points.isNotEmpty)
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.points.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (data.points.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}. ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  Expanded(
                                      child: StyledTextWidget(
                                          text: data.points[index],
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 16)),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: StyledTextWidget(
                                    text: data.points[index],
                                    color: Colors.amberAccent,
                                    fontSize: 20));
                          }
                        }),
                  if (data.table.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.table
                              .length, // Number of rows including the header
                          itemBuilder: (context, index) {
                            TableConvertor subTechnicalParameters =
                                data.table[index];
                            return Table(
                              border: TableBorder.all(
                                  width: 0.5,
                                  color: Colors.white,
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))
                                      : index == data.table.length - 1
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15))
                                          : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FractionColumnWidth(0.2),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          subTechnicalParameters.col0,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters.col1,
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
                  if (data.files.isNotEmpty)
                    ListView.builder(
                        itemCount: data.files.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          final fdata = data.files[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CodeFileView(
                                  code: fdata.code,
                                  lang: fdata.lang,
                                );
                              }));
                            },
                            child: Container(
                              // constraints: BoxConstraints(maxHeight: 200),
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                // border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 50,
                                      child:
                                          Image.asset("assets/file_icon.png")),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fdata.heading,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(fdata.lang),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class CodeFileView extends StatefulWidget {
  String code;
  String lang;

  CodeFileView({required this.code, required this.lang});

  @override
  State<CodeFileView> createState() => _CodeFileViewState();
}

class _CodeFileViewState extends State<CodeFileView> {
  double FontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Code copied to clipboard')),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        Text(
                          " Copy Code",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (FontSize < 30) {
                            setState(() {
                              FontSize++;
                            });
                          } else {
                            showToastText("Max Size");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white),
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          if (FontSize < 5) {
                            showToastText("Min Size");
                          } else {
                            setState(() {
                              FontSize--;
                            });
                          }
                        },
                        child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            margin:EdgeInsets.symmetric( horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white),
                            child: Text(
                              "-",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))),
                  ],
                )
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: HighlightView(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 150),
                      widget.code,
                      language: widget.lang,
                      theme: githubTheme,
                tabSize:20,
                      textStyle:
                          TextStyle(fontSize: FontSize), // Set the font size
                    ),
                  ),
                  Positioned(bottom:0,left: 0,right: 0,child:   Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomAdsBannerForPdfs(  ),
                  ))
                ],
              ),
            ),

          ],
        ),
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
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingWithDivider(
            heading: "Making Video",
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
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                      child: Text(
                        "Play",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        Text(
                          " View On ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Container(
                            height: 40,
                            width: 100,
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

  const StyledTextWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      bool isLastWord = i == words.length - 1;

      if (word.startsWith('**')) {
        spans.add(TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.white54),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  word.substring(2),
                  style: TextStyle(color: Colors.black, fontSize: fontSize - 5),
                ),
              ),
            ),
            if (!isLastWord) TextSpan(text: ' '),
            // Add space only if not the last word
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
        spans.add(TextSpan(text: '$word'));
        if (!isLastWord)
          spans.add(TextSpan(text: ' ')); // Add space only if not the last word
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style:
            TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
      ),
    );
  }
}

String calculateTimeDifference(String inputDate) {
  DateTime parsedDate = DateFormat("HH:mm:ss-dd.MM.yyyy").parse(inputDate);
  DateTime currentDate = DateTime.now();

  Duration difference = currentDate.difference(parsedDate);

  if (difference.inDays > 365) {
    int years = difference.inDays ~/ 365;
    return "$years y ago";
  } else if (difference.inDays > 30) {
    int months = difference.inDays ~/ 30;
    return "$months m ago";
  } else if (difference.inDays > 0) {
    return "${difference.inDays} d ago";
  } else if (difference.inHours > 0) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0) {
    return "${difference.inMinutes} min ago";
  } else {
    return "${difference.inSeconds} sec ago";
  }
}

Future<String> getFileUrl(String? fileId) async {
  if (fileId == null) {
    throw Exception('File ID is null');
  }

  try {
    String url = 'https://api.telegram.org/bot$token/getFile?file_id=$fileId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String filePath = data['result']['file_path'];
      return 'https://api.telegram.org/file/bot$token/$filePath';
    } else {
      throw Exception('Failed to get file URL');
    }
  } catch (e) {
    print('Failed to get file URL. Retrying attempt');
    return "";
  }
}
