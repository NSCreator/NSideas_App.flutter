import 'package:flutter/material.dart';

import '../functions.dart';
import 'converter.dart';

class arduinoBoard extends StatefulWidget {
  BoardsConverter data;

  arduinoBoard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<arduinoBoard> createState() => _arduinoBoardState();
}

class _arduinoBoardState extends State<arduinoBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(
                  text: widget.data.heading.short,
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.data.images.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: scrollingImages(
                            images: widget.data.images,
                            id: widget.data.id,
                            isZoom: true,
                          ),
                        ),
                      if (widget.data.heading.full.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            widget.data.heading.full,
                            style: TextStyle(fontSize: 25, color: Colors.black,fontWeight: FontWeight.w500),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                        height: 1,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    Text(
                                      "About",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                        height: 1,
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ],
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
                ),
                Description(
                  id: widget.data.id,
                  data: widget.data.descriptions, mode: 'boards',
                ),
                if (widget.data.pinDiagrams.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                    child: Text(
                      "PinOut",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                if (widget.data.pinDiagrams.isNotEmpty)scrollingImages(
                  images: widget.data.pinDiagrams,
                  id: widget.data.id,
                  isZoom: true,
                ),
                Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "---${widget.data.heading.full}---",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
