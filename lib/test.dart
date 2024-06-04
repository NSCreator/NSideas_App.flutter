// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/Description/creator.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import 'functions.dart';

class ProjectCreator extends StatefulWidget {
  ProjectConverter? data;

  ProjectCreator({
    super.key,
    this.data,
  });

  @override
  State<ProjectCreator> createState() => _ProjectCreatorState();
}

class _ProjectCreatorState extends State<ProjectCreator> {
  final HeadingFirstController = TextEditingController();
  final HeadingLastController = TextEditingController();
  FileUploader? IVF_Thumbnail;
  final DescriptionController = TextEditingController();
  final TypeController = TextEditingController();

  List<FileUploader> IVF_Images = [];

  void AutoFill() {
    setState(() {
      isFree = widget.data!.isFree;
      if(widget.data!.thumbnail.fileName.isNotEmpty)IVF_Thumbnail= widget.data!.thumbnail;
      isContainsAds = widget.data!.isContainsAds;
      descriptionList = widget.data!.description;
      HeadingFirstController.text = widget.data!.heading.short;
      HeadingLastController.text = widget.data!.heading.full;
      TypeController.text = widget.data!.type;
      youtubeData = widget.data!.youtubeData;
      IVF_Images = widget.data!.images;
      DescriptionController.text = widget.data!.about;
      tableOfContentList = widget.data!.tableOfContent;
      TagsList = widget.data!.tags;
      appAndPlatforms = widget.data!.appAndPlatforms;
      toolsRequired = widget.data!.toolsRequired;
      ComponentsAndSupplies = widget.data!.componentsAndSupplies;
    });
  }

  @override
  void initState() {
    if (widget.data != null) AutoFill();
    super.initState();
  }

  bool isFree = true;
  bool isContainsAds = true;
  List<YoutubeConvertor> youtubeData = [];
  final YoutubeLinkController = TextEditingController();

  List<DescriptionConvertor> descriptionList = [];

  List<ConvertorForTRCSRC> ComponentsAndSupplies = [];
  final TextEditingController Heading_ComponentsAndSupplies_Controller =
  TextEditingController();
  final TextEditingController PathName_ComponentsAndSupplies_Controller =
  TextEditingController();
  final TextEditingController PathId_ComponentsAndSupplies_Controller =
  TextEditingController();

  List<ConvertorForTRCSRC> toolsRequired = [];
  final TextEditingController Heading_toolsRequired_Controller =
  TextEditingController();
  final TextEditingController PathName_toolsRequired_Controller =
  TextEditingController();
  final TextEditingController PathId_toolsRequired_Controller =
  TextEditingController();

  List<ConvertorForTRCSRC> appAndPlatforms = [];
  final TextEditingController Heading_appAndPlatforms_Controller =
  TextEditingController();
  final TextEditingController PathName_appAndPlatforms_Controller =
  TextEditingController();
  final TextEditingController PathId_appAndPlatforms_Controller =
  TextEditingController();
  FileUploader? IVF_ConvertorForTRCSRC;
  int selectedConvertorForTRCSRC = -1;


  List<String> tableOfContentList = [];
  final tableOfContentController = TextEditingController();
  int selectedTableOfContentIndex = -1;

  List<String> TagsList = [];
  final TextEditingController _TagsController = TextEditingController();
  int selectedTagsIndex = -1;
  int selectedYoutubeIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            HeadingH1(heading: "Project Creator"),

            TextFieldContainer(
              controller: HeadingFirstController,
              hintText: 'Short Heading',


              heading: "Short Heading",
            ),
            TextFieldContainer(
              controller: HeadingLastController,
              hintText: 'Full Heading',


              heading: "Long Heading",
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Thumbnail"),
                  if(IVF_Thumbnail!=null)SizedBox(height: 100,width: 150,child: Image.network(IVF_Thumbnail!.fileUrl),),
                  Uploader(

                    type: FileType.image,
                    path: "projects",

                    getIVF: (data) {
                      setState(() {
                        IVF_Thumbnail = data.first;
                      });
                    },
                    IVF: IVF_Thumbnail!=null?[IVF_Thumbnail!]:[],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Other Images"),
                  Uploader(
                    type: FileType.image,
                    path: "projects",
                    allowMultiple: true,
                    getIVF: (data) {
                      setState(() {
                        IVF_Images = data;
                      });
                    },
                    IVF: IVF_Images,
                  ),
                ],
              ),
            ),

            TextFieldContainer(
              controller: TypeController,
              hintText: 'Projects Type',


              heading: "Projects Type",
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "YouTube"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      youtubeData.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(youtubeData[index].video_url,style: TextStyle(color: Colors.white),)),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedYoutubeIndex = index;
                                        YoutubeLinkController.text = youtubeData[index].video_url;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.edit),
                                    )),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        youtubeData.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.delete,color: Colors.orangeAccent,)),
                              ],
                            ),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }

                        youtubeData.insert(newIndex, youtubeData.removeAt(oldIndex));
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          controller: YoutubeLinkController,
                          hintText: 'Enter Youtube Videos Urls',

                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            selectedYoutubeIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedYoutubeIndex >= 0) {
                              youtubeData[selectedYoutubeIndex] =YoutubeConvertor(video_url: YoutubeLinkController.text, heading: "Neo Pixel LEDs lighting", note: "This is the First video must be watch for more connects", thumbnail_url: "");
                            } else {
                              youtubeData.add(YoutubeConvertor(video_url: YoutubeLinkController.text, heading: "", note: "", thumbnail_url: ""));
                            }
                          });
                          selectedYoutubeIndex = -1;
                          YoutubeLinkController.clear();
                        },
                      )
                    ],
                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Tags"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      TagsList.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(TagsList[index])),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedTagsIndex = index;
                                        _TagsController.text = TagsList[index];
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.edit),
                                    )),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        TagsList.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }

                        TagsList.insert(newIndex, TagsList.removeAt(oldIndex));
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          controller: _TagsController,
                          hintText: 'Enter Tags Here',
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            selectedTagsIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedTagsIndex >= 0) {
                              TagsList[selectedTagsIndex] =
                                  _TagsController.text;
                            } else {
                              TagsList.add(_TagsController.text);
                            }
                          });
                          selectedTagsIndex = -1;
                          _TagsController.clear();
                        },
                      )
                    ],
                  ),

                ],
              ),
            ),

            TextFieldContainer(
              heading: "About Project",
              controller: DescriptionController,
              hintText: 'Description',
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Table Of Content"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      tableOfContentList.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(tableOfContentList[index])),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedTableOfContentIndex = index;
                                        tableOfContentController.text =
                                        tableOfContentList[index];
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.edit),
                                    )),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        tableOfContentList.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        tableOfContentList.insert(newIndex, tableOfContentList
                            .removeAt(oldIndex));
                      });
                    },
                  ),


                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          controller: tableOfContentController,
                          hintText: 'Enter Tags Here',
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            selectedTableOfContentIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedTableOfContentIndex >= 0) {
                              tableOfContentList[selectedTableOfContentIndex] =
                                  tableOfContentController.text;
                            } else {
                              tableOfContentList.add(
                                  tableOfContentController.text);
                            }
                          });
                          selectedTableOfContentIndex = -1;
                          tableOfContentController.clear();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Text(
                      "Description List",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      descriptionList.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        descriptionList[index].heading)),
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


            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Components And Supplies"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      ComponentsAndSupplies.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: convertorForTRCSRCContainer(
                                ComponentsAndSupplies[index], 1, index),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ConvertorForTRCSRC item =
                        ComponentsAndSupplies.removeAt(oldIndex);
                        ComponentsAndSupplies.insert(newIndex, item);
                      });
                    },
                  ),
                  Column(
                    children: [
                      TextFieldContainer(
                          heading: "Heading",
                          controller: Heading_ComponentsAndSupplies_Controller,
                          hintText: 'Heading',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Name",
                                controller:
                                PathName_ComponentsAndSupplies_Controller,
                                hintText: 'name',
                            ),
                          ),
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Id",
                                hintText: 'Id',
                                controller:
                                PathId_ComponentsAndSupplies_Controller,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Uploader(
                                type: FileType.any,
                                path: "project",
                                getIVF: (IVFData) {
                                  setState(() {
                                    IVF_ConvertorForTRCSRC = IVFData.first;
                                  });
                                },
                              )),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedConvertorForTRCSRC >= 0
                                    ? "Save"
                                    : "Add",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedConvertorForTRCSRC >= 0) {
                                  ComponentsAndSupplies[selectedConvertorForTRCSRC] =
                                      ConvertorForTRCSRC(
                                          heading:
                                          Heading_ComponentsAndSupplies_Controller
                                              .text,
                                          path: Path(
                                              path:
                                              PathName_ComponentsAndSupplies_Controller
                                                  .text,
                                              id: PathId_ComponentsAndSupplies_Controller
                                                  .text),
                                          ivf: IVF_ConvertorForTRCSRC != null
                                              ? IVF_ConvertorForTRCSRC!
                                              : FileUploader(
                                              type: "",
                                              fileUrl: "",
                                              fileName: "",
                                              size: "",
                                              fileMessageId: 0,
                                              thumbnailUrl: "",
                                              thumbnailMessageId: 0));
                                } else
                                  ComponentsAndSupplies.add(ConvertorForTRCSRC(
                                      heading:
                                      Heading_ComponentsAndSupplies_Controller
                                          .text,
                                      path: Path(
                                          path:
                                          PathName_ComponentsAndSupplies_Controller
                                              .text,
                                          id: PathId_ComponentsAndSupplies_Controller
                                              .text),
                                      ivf: IVF_ConvertorForTRCSRC != null
                                          ? IVF_ConvertorForTRCSRC!
                                          : FileUploader(
                                          type: "",
                                          fileUrl: "",
                                          fileName: "",
                                          size: "",
                                          fileMessageId: 0,
                                          thumbnailUrl: "",
                                          thumbnailMessageId: 0)));
                                selectedConvertorForTRCSRC = -1;
                                IVF_ConvertorForTRCSRC = null;
                              });

                              Heading_ComponentsAndSupplies_Controller.clear();
                              PathName_ComponentsAndSupplies_Controller.clear();
                              PathId_ComponentsAndSupplies_Controller.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Tools Required"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      toolsRequired.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: convertorForTRCSRCContainer(
                                toolsRequired[index], 2, index),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ConvertorForTRCSRC item =
                        toolsRequired.removeAt(oldIndex);
                        toolsRequired.insert(newIndex, item);
                      });
                    },
                  ),
                  Column(
                    children: [
                      TextFieldContainer(
                          heading: "Heading",
                          controller: Heading_toolsRequired_Controller,
                          hintText: 'Heading',

                          ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Name",
                                controller:
                                PathName_toolsRequired_Controller,
                                hintText: 'name',
                                ),
                          ),
                          Expanded(
                            child: TextFieldContainer(
                                controller:
                                PathId_toolsRequired_Controller,
                                heading: "Path Id",
                                hintText: 'Id',

                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Uploader(
                                type: FileType.any,
                                path: "project",
                                getIVF: (IVFData) {
                                  setState(() {
                                    IVF_ConvertorForTRCSRC = IVFData.first;
                                  });
                                },
                              )),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedConvertorForTRCSRC >= 0
                                    ? "Save"
                                    : "Add",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedConvertorForTRCSRC >= 0) {
                                  toolsRequired[selectedConvertorForTRCSRC] =
                                  ConvertorForTRCSRC(
                                      heading:
                                      Heading_toolsRequired_Controller
                                          .text,
                                      path: Path(
                                          path:
                                          PathName_toolsRequired_Controller
                                              .text,
                                          id: PathId_toolsRequired_Controller
                                              .text),
                                      ivf: IVF_ConvertorForTRCSRC != null
                                          ? IVF_ConvertorForTRCSRC!
                                          : FileUploader(
                                          type: "",
                                          fileUrl: "",
                                          fileName: "",
                                          size: "",
                                          fileMessageId: 0,
                                          thumbnailUrl: "",
                                          thumbnailMessageId: 0));
                                } else
                                  toolsRequired.add(ConvertorForTRCSRC(
                                      heading:
                                      Heading_toolsRequired_Controller
                                          .text,
                                      path: Path(
                                          path:
                                          PathName_toolsRequired_Controller
                                              .text,
                                          id: PathId_toolsRequired_Controller
                                              .text),
                                      ivf: IVF_ConvertorForTRCSRC != null
                                          ? IVF_ConvertorForTRCSRC!
                                          : FileUploader(
                                          type: "",
                                          fileUrl: "",
                                          fileName: "",
                                          size: "",
                                          fileMessageId: 0,
                                          thumbnailUrl: "",
                                          thumbnailMessageId: 0)));
                                selectedConvertorForTRCSRC = -1;
                                IVF_ConvertorForTRCSRC = null;
                              });

                              Heading_toolsRequired_Controller.clear();
                              PathName_toolsRequired_Controller.clear();
                              PathId_toolsRequired_Controller.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Apps And Platforms"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      appAndPlatforms.length,
                          (index) =>
                          Container(
                            key: ValueKey(index),
                            // Assign a unique key to each item
                            padding: EdgeInsets.symmetric(vertical: 5),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: convertorForTRCSRCContainer(
                                appAndPlatforms[index], 0, index),
                          ),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ConvertorForTRCSRC item =
                        appAndPlatforms.removeAt(oldIndex);
                        appAndPlatforms.insert(newIndex, item);
                      });
                    },
                  ),
                  Column(
                    children: [
                      TextFieldContainer(
                          heading: "Heading",
                          controller: Heading_appAndPlatforms_Controller,
                          hintText: 'Heading',

                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Name",
                                controller:
                                PathName_appAndPlatforms_Controller,
                                hintText: 'name',
                            ),
                          ),
                          Expanded(
                            child: TextFieldContainer(
                                controller:
                                PathId_appAndPlatforms_Controller,
                                heading: "Path Id",
                                hintText: 'Id',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Uploader(
                                type: FileType.any,
                                path: "project",
                                getIVF: (IVFData) {
                                  setState(() {
                                    IVF_ConvertorForTRCSRC = IVFData.first;
                                  });
                                },
                              )),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedConvertorForTRCSRC >= 0
                                    ? "Save"
                                    : "Add",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedConvertorForTRCSRC >= 0) {
                                  appAndPlatforms[selectedConvertorForTRCSRC] =
                                      ConvertorForTRCSRC(
                                          heading:
                                          Heading_appAndPlatforms_Controller
                                              .text,
                                          path: Path(
                                              path:
                                              PathName_appAndPlatforms_Controller
                                                  .text,
                                              id: PathId_appAndPlatforms_Controller
                                                  .text),
                                          ivf: IVF_ConvertorForTRCSRC != null
                                              ? IVF_ConvertorForTRCSRC!
                                              : FileUploader(
                                              type: "",
                                              fileUrl: "",
                                              fileName: "",
                                              size: "",
                                              fileMessageId: 0,
                                              thumbnailUrl: "",
                                              thumbnailMessageId: 0));
                                } else
                                  appAndPlatforms.add(ConvertorForTRCSRC(
                                      heading:
                                      Heading_appAndPlatforms_Controller
                                          .text,
                                      path: Path(
                                          path:
                                          PathName_appAndPlatforms_Controller
                                              .text,
                                          id: PathId_appAndPlatforms_Controller
                                              .text),
                                      ivf: IVF_ConvertorForTRCSRC != null
                                          ? IVF_ConvertorForTRCSRC!
                                          : FileUploader(
                                          type: "",
                                          fileUrl: "",
                                          fileName: "",
                                          size: "",
                                          fileMessageId: 0,
                                          thumbnailUrl: "",
                                          thumbnailMessageId: 0)));
                                selectedConvertorForTRCSRC = -1;
                                IVF_ConvertorForTRCSRC = null;
                              });

                              Heading_appAndPlatforms_Controller.clear();
                              PathName_appAndPlatforms_Controller.clear();
                              PathId_appAndPlatforms_Controller.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Is Free ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Switch(
                        value: isFree,
                        onChanged: (value) {
                          setState(() {
                            isFree = value;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Is Contains Ads ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Switch(
                        value: isContainsAds,
                        onChanged: (value) {
                          setState(() {
                            isContainsAds = value;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
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
                  onTap: () {
                    String id = getID();
                    createProject(
                        displayHere: [],
                        thumbnail: IVF_Thumbnail!=null?IVF_Thumbnail!:FileUploader(
                            type: "",
                            fileUrl: "",
                            fileName: "",
                            size: "",
                            fileMessageId: 0,
                            thumbnailUrl: "",
                            thumbnailMessageId: 0),
                        isContainsAds: isContainsAds,
                        isFree: isFree,
                        id: widget.data == null ? id : widget.data!.id,
                        type: TypeController.text,

                        isUpdate: widget.data != null ? true : false,
                        heading: HeadingConvertor(
                            full: HeadingLastController.text,
                            short: HeadingFirstController.text),
                        about: DescriptionController.text,
                        tags: TagsList,
                        tableOfContent: tableOfContentList,
                        componentsAndSupplies: ComponentsAndSupplies,
                        appAndPlatforms: appAndPlatforms,
                        toolsRequired: toolsRequired,
                        description: descriptionList,
                        images: IVF_Images, youtubeData: youtubeData);

                    Navigator.pop(context);
                  },
                  child: widget.data == null
                      ? Container(
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
                  )
                      : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Update"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget convertorForTRCSRCContainer(ConvertorForTRCSRC data, int mode,
      int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.heading}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "IVF : ${data.ivf.fileName}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "Path : ${data.path.path}/${data.path.id}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedConvertorForTRCSRC = index;
                        if (mode == 0) {
                          Heading_appAndPlatforms_Controller.text =
                              appAndPlatforms[index].heading;
                          PathName_appAndPlatforms_Controller.text =
                              appAndPlatforms[index].path.path;
                          ;
                          PathId_appAndPlatforms_Controller.text =
                              appAndPlatforms[index].path.id;
                          ;
                        }else if(mode == 1){
                          Heading_ComponentsAndSupplies_Controller.text =
                              ComponentsAndSupplies[index].heading;
                          PathName_ComponentsAndSupplies_Controller.text =
                              ComponentsAndSupplies[index].path.path;
                          ;
                          PathId_ComponentsAndSupplies_Controller.text =
                              ComponentsAndSupplies[index].path.id;
                          ;
                        }else if(mode == 2){
                          Heading_toolsRequired_Controller.text =
                              toolsRequired[index].heading;
                          PathName_toolsRequired_Controller.text =
                              toolsRequired[index].path.path;
                          ;
                          PathId_toolsRequired_Controller.text =
                              toolsRequired[index].path.id;
                          ;
                        }
                      });
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.black54,
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        if (mode == 2) {
                          deleteFileFromTelegramBot(
                              appAndPlatforms[index].ivf.fileMessageId);
                          deleteFileFromTelegramBot(
                              appAndPlatforms[index].ivf.thumbnailMessageId);
                          appAndPlatforms.removeAt(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class Point {
  String name;
  String score;

  Point({required this.name, required this.score});
}
