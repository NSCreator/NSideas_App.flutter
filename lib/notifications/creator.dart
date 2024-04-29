import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/home_page/home_page.dart';
import 'package:nsideas/notifications/converter.dart';

import '../message/messaging_page.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../settings/settings.dart';
import '../test1.dart';

class NotificationCreator extends StatefulWidget {
  NotificationCreator();

  @override
  State<NotificationCreator> createState() => _NotificationCreatorState();
}

class _NotificationCreatorState extends State<NotificationCreator> {
  TextEditingController HeadingController = TextEditingController();

  TextEditingController YoutubeController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  List<String> list =[];

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
              TextFieldContainer(
                  heading: "Heading",
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'short',
                        hintStyle: TextStyle(color: Colors.black)),
                  )),
              // Uploader(
              //   onChanged: (value) {
              //
              //     setState(() {
              //       list= value;
              //     });
              //
              //   }, type: FileType.image,
              //   allowMultiple: true,
              // ),

              TextFieldContainer(
                  heading: "Youtube Url",
                  child: TextFormField(
                    controller: YoutubeController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'short',
                        hintStyle: TextStyle(color: Colors.black)),
                  )),
              TextFieldContainer(
                  heading: "Description",
                  child: TextFormField(
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'short',
                        hintStyle: TextStyle(color: Colors.black)),
                  )),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Back"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () async {
                          String id = getID();
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(id)
                              .set(NotificationConverter(
                                      id: id,
                                      heading: HeadingController.text.trim(),
                                      description:
                                          DescriptionController.text.trim(),
                                      image: list,
                                      youtube: YoutubeController.text.trim())
                                  .toJson());
                          SendMessage(
                              HeadingController.text.trim(),
                              DescriptionController.text.trim(),
                              {"navigation": "notification"});
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

