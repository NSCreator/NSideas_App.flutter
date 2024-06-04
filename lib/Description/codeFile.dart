import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:nsideas/functions.dart';

import '../ads/ads.dart';

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
      backgroundColor: Colors.white,
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
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: InteractiveViewer(
                  panEnabled: false,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.2,
                  child: HighlightView(

                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 150),
                    widget.code,
                    language: widget.lang,

                    theme: githubTheme,
                    tabSize: 20,
                    textStyle:
                    TextStyle(fontSize: FontSize), // Set the font size
                  ),
                ),
              ),
            ),
            CustomAdsBannerForPdfs()
          ],
        ),
      ),
    );
  }
}
