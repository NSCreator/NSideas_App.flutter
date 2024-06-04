import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/test.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import '../functions.dart';
import '../project_files/projects_test.dart';
import '../test1.dart';
import 'converter.dart';

class BoardCreator extends StatefulWidget {
  BoardsConverter? data;

  BoardCreator({this.data});

  @override
  State<BoardCreator> createState() => _BoardCreatorState();
}

class _BoardCreatorState extends State<BoardCreator> {
  final shortController = TextEditingController();
  final fullController = TextEditingController();
  final AboutController = TextEditingController();
  final TypeController = TextEditingController();
  List<DescriptionConvertor> descriptionList = [];
  List<FileUploader> images = [];
  FileUploader? thumbnail;
  FileUploader? pinDiagram;

  autoFill() {
    setState(() {
      shortController.text = widget.data!.heading.short;
      fullController.text = widget.data!.heading.full;
      AboutController.text = widget.data!.about;
      TypeController.text = widget.data!.type;
      thumbnail = widget.data!.thumbnail;
      images = widget.data!.images;
      pinDiagram = widget.data!.pinDiagram;
      descriptionList = widget.data!.descriptions;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) autoFill();
  }

  @override
  void dispose() {
    shortController.dispose();
    AboutController.dispose();
    super.dispose();
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
              backButton(
                text: "Arduino Board",
              ),
              TextFieldContainer(
                heading: "Short Heading",
                controller: shortController,
                hintText: 'Short',


              ),
              TextFieldContainer(
                heading: "Full Heading",
                controller: fullController,
                hintText: 'Full',

              ),
              TextFieldContainer(
                heading: "About",
                controller: AboutController,
                hintText: 'About',

              ),
              HeadingH2(heading: "Thumbnail Image"),

              Uploader(
                IVF: thumbnail != null
                    ? thumbnail!.fileUrl.isNotEmpty?[thumbnail!]:[]
                    : [],
                getIVF: (value) {
                  setState(() {
                    thumbnail = value.first;
                  });

                  print(value.first.toJson());
                },
                type: FileType.image,
                path: 'board',
              ),
              HeadingH2(heading: "Other Images"),
              Uploader(
                IVF: widget.data != null ? widget.data!.images : [],
                getIVF: (value) {
                  setState(() {
                    images = value;
                  });
                },
                allowMultiple: true,
                type: FileType.image,
                path: 'board',
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                color: Colors.white10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 8),
                      child: Text(
                        "Description List",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      ),
                    ),
                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                      children: List.generate(
                        descriptionList.length,
                        (index) => Container(
                          key: ValueKey(index),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(descriptionList[index].heading,style: TextStyle(color: Colors.white),)),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      descriptionList.removeAt(index);
                                    });
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final DescriptionConvertor item =
                              descriptionList.removeAt(oldIndex);
                          descriptionList.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                ),
              ),
              HeadingH2(heading: "Pin Diagram"),
              Uploader(
                IVF: pinDiagram != null
                    ? pinDiagram!.fileUrl.isNotEmpty?[pinDiagram!]:[]
                    : [],
                getIVF: (value) {
                  setState(() {
                    pinDiagram = value.first;
                  });
                },
                type: FileType.image,
                path: 'board',
              ),
              TextFieldContainer(
                heading: "Type",
                controller: TypeController,
                hintText: 'Type',

              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Spacer(),
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
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Back"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () async {
                        String id = getID();
                        if (widget.data == null) {
                          await FirebaseFirestore.instance
                              .collection("boards")
                              .doc(id)
                              .set(BoardsConverter(
                                id: id,
                                heading: HeadingConvertor(
                                  full: fullController.text,
                                  short: shortController.text,
                                ),
                                images: images,
                                about: AboutController.text,
                                type: TypeController.text,
                                descriptions: descriptionList,
                                pinDiagram: pinDiagram != null
                                    ? pinDiagram!
                                    : FileUploader(
                                        type: "",
                                        fileUrl: "",
                                        fileName: "",
                                        size: "",
                                        fileMessageId: 0,
                                        thumbnailUrl: "",
                                        thumbnailMessageId: 0),
                                thumbnail: thumbnail != null
                                    ? thumbnail!
                                    : FileUploader(
                                        type: "",
                                        fileUrl: "",
                                        fileName: "",
                                        size: "",
                                        fileMessageId: 0,
                                        thumbnailUrl: "",
                                        thumbnailMessageId: 0),
                              ).toJson());
                        } else {
                          await FirebaseFirestore.instance
                              .collection("boards")
                              .doc(widget.data!.id)
                              .update(BoardsConverter(
                                id: widget.data!.id,
                                heading: HeadingConvertor(
                                  full: fullController.text,
                                  short: shortController.text,
                                ),
                                images: images,
                                about: AboutController.text,
                                type: TypeController.text,
                                descriptions: descriptionList,
                                pinDiagram: pinDiagram != null
                                    ? pinDiagram!
                                    : FileUploader(
                                        type: "",
                                        fileUrl: "",
                                        fileName: "",
                                        size: "",
                                        fileMessageId: 0,
                                        thumbnailUrl: "",
                                        thumbnailMessageId: 0),
                                thumbnail: thumbnail != null
                                    ? thumbnail!
                                    : FileUploader(
                                        type: "",
                                        fileUrl: "",
                                        fileName: "",
                                        size: "",
                                        fileMessageId: 0,
                                        thumbnailUrl: "",
                                        thumbnailMessageId: 0),
                              ).toJson());
                        }

                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Create"),
                        ),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
