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
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/test.dart';
import 'package:nsideas/textFeild.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

String getID() => DateFormat('d.M.y-kk:mm:ss').format(DateTime.now());

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

class HeadingH1 extends StatelessWidget {
  String heading;

  HeadingH1({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10,right: 10,bottom: 5),
      child: Text(
        heading,
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

class HeadingH2 extends StatelessWidget {
  String heading;

  HeadingH2({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10,right: 10,bottom: 5),
      child: Text(
        heading,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  String heading;
  final controller;
  final String hintText;
  final bool obscureText;

  TextFieldContainer(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      this.heading = ""});

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
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
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
                  body: SafeArea(
                    child: Column(
                      children: [
                        backButton(),
                        Expanded(
                          child: InteractiveViewer(
                            child: Center(
                              child: Image.file(
                                File(filePath),
                                fit: BoxFit.contain,
                              ),
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
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.black87,
                  ),
                  Text(
                    "back ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
              return ClipRRect(
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
          color: Colors.white10,
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
                          color: Colors.white54,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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

class ConvertorForTRCSRC_Container extends StatefulWidget {
  List<ConvertorForTRCSRC> data;
  String title;

  ConvertorForTRCSRC_Container({required this.data, required this.title});

  @override
  State<ConvertorForTRCSRC_Container> createState() =>
      _ConvertorForTRCSRC_ContainerState();
}

class _ConvertorForTRCSRC_ContainerState
    extends State<ConvertorForTRCSRC_Container> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(15),
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
                        color: Colors.white54,
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
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        if (data.ivf.fileUrl.isNotEmpty)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      zoom(url: data.ivf.fileUrl)));
                        else {
                          showToastText("Image Not Found");
                        }
                      },
                    ),
                  ),
                  if (data.path != null)
                    InkWell(
                      onTap: () {
                        showToastText(
                            "Go to ${data.path.path.isNotEmpty ? data.path.path : "No Path"}");
                      },
                      child: Icon(
                        Icons.open_in_new,
                        color: Colors.orangeAccent,
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
      body: InteractiveViewer(
        child: Image.network(widget.url),
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
    this.color = Colors.white,
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
