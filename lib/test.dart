// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/project_files/sub_page.dart';
import 'package:nsideas/sensors/sub_page.dart';
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
  final DescriptionController = TextEditingController();
  final tableOfContentController = TextEditingController();
  final TypeController = TextEditingController();
  final YoutubeLinkController = TextEditingController();
  List<IVFUploader> iv = [];

  void AutoFill() {

    setState(() {
      isFree = widget.data!.isFree;
      isContainsAds = widget.data!.isContainsAds;
      descriptionList = widget.data!.description;
      HeadingFirstController.text = widget.data!.heading.short;
      HeadingLastController.text = widget.data!.heading.full;
      TypeController.text = widget.data!.type;
      YoutubeLinkController.text = widget.data!.youtubeUrl;
      iv = widget.data!.images;
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

  int selectedFilesIndex = -1;
  final TextEditingController _HeadingFilesController = TextEditingController();
  final TextEditingController _DataFilesController = TextEditingController();
  final TextEditingController _TypeFilesController = TextEditingController();

  // void addFiles() {
  //   setState(() {
  //     appAndPlatforms.add(ConvertorForTRCSRC(
  //         heading: _HeadingFilesController.text,
  //         path: _TypeFilesController.text, IVF:
  //     ));
  //     _HeadingFilesController.clear();
  //     _DataFilesController.clear();
  //     _TypeFilesController.clear();
  //   });
  // }
  //
  // void editFiles(int index) {
  //   setState(() {
  //     selectedFilesIndex = index;
  //     _HeadingFilesController.text = appAndPlatforms[index].heading;
  //     _DataFilesController.text = appAndPlatforms[index].image;
  //     _TypeFilesController.text = appAndPlatforms[index].path;
  //   });
  // }

  // void saveFiles() {
  //   if (selectedFilesIndex != -1) {
  //     setState(() {
  //       items[selectedFilesIndex].heading = _HeadingFilesController.text;
  //       items[selectedFilesIndex].image = _DataFilesController.text;
  //       items[selectedFilesIndex].link = _TypeFilesController.text;
  //
  //       _HeadingFilesController.clear();
  //       _DataFilesController.clear();
  //       _TypeFilesController.clear();
  //
  //       selectedFilesIndex = -1;
  //     });
  //   }
  // }
  bool isFree = true;
  bool isContainsAds = true;
  List<DescriptionConvertor> descriptionList = [];
  List<ConvertorForTRCSRC> ComponentsAndSupplies = [];
  final TextEditingController Heading_ConvertorForTRCSRC_Controller =
      TextEditingController();
  final TextEditingController PathName_ConvertorForTRCSRC_Controller =
      TextEditingController();
  final TextEditingController PathId_ConvertorForTRCSRC_Controller =
      TextEditingController();
  IVFUploader? IVF_ComponentsAndSupplies;

  List<ConvertorForTRCSRC> appAndPlatforms = [];

  IVFUploader? IVF_appAndPlatforms;
  int selectedConvertorForTRCSRC = -1;

  List<ConvertorForTRCSRC> toolsRequired = [];

  IVFUploader? IVF_toolsRequired;
  int selectedImageIndex = -1;

  List<String> tableOfContentList = [];
  final TextEditingController _tableOfContentController =
      TextEditingController();
  int selectedtableOfContentIndex = -1;

  List<String> TagsList = [];
  final TextEditingController _TagsController = TextEditingController();
  int selectedTagsIndex = -1;

  void addTags() {
    String points = _TagsController.text;
    if (points.isNotEmpty) {
      setState(() {
        TagsList.add(points);
        _TagsController.clear();
      });
    }
  }

  void editTags(int index) {
    setState(() {
      selectedTagsIndex = index;
      _TagsController.text = TagsList[index];
    });
  }

  void saveTags() {
    String editedImage = _TagsController.text;
    if (editedImage.isNotEmpty && selectedTagsIndex != -1) {
      setState(() {
        TagsList[selectedImageIndex] = editedImage;
        _TagsController.clear();
        selectedTagsIndex = -1;
      });
    }
  }

  void deleteTags(int index) {
    setState(() {
      TagsList.removeAt(index);
      if (selectedTagsIndex == index) {
        selectedTagsIndex = -1;
        _TagsController.clear();
      }
    });
  }

  void moveTagsUp(int index) {
    if (index > 0) {
      setState(() {
        String point = TagsList.removeAt(index);
        TagsList.insert(index - 1, point);
        if (selectedTagsIndex == index) {
          selectedTagsIndex--;
        }
      });
    }
  }

  void moveTagsDown(int index) {
    if (index < TagsList.length - 1) {
      setState(() {
        String Image = TagsList.removeAt(index);
        TagsList.insert(index + 1, Image);
        if (selectedTagsIndex == index) {
          selectedTagsIndex++;
        }
      });
    }
  }

  void addtableOfContent() {
    String points = _tableOfContentController.text;
    if (points.isNotEmpty) {
      setState(() {
        tableOfContentList.add(points);
        _tableOfContentController.clear();
      });
    }
  }

  void edittableOfContent(int index) {
    setState(() {
      selectedtableOfContentIndex = index;
      _tableOfContentController.text = tableOfContentList[index];
    });
  }

  void savetableOfContent() {
    String editedImage = _tableOfContentController.text;
    if (editedImage.isNotEmpty && selectedtableOfContentIndex != -1) {
      setState(() {
        tableOfContentList[selectedtableOfContentIndex] = editedImage;
        _tableOfContentController.clear();
        selectedtableOfContentIndex = -1;
      });
    }
  }

  void deletetableOfContent(int index) {
    setState(() {
      tableOfContentList.removeAt(index);
      if (selectedtableOfContentIndex == index) {
        selectedtableOfContentIndex = -1;
        _tableOfContentController.clear();
      }
    });
  }

  void movetableOfContentUp(int index) {
    if (index > 0) {
      setState(() {
        String point = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index - 1, point);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex--;
        }
      });
    }
  }

  void movetableOfContentDown(int index) {
    if (index < tableOfContentList.length - 1) {
      setState(() {
        String Image = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index + 1, Image);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Heading",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: HeadingFirstController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Short Heading',
                    hintStyle: TextStyle(color: Colors.black54)),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: HeadingLastController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Full Heading',
                    hintStyle: TextStyle(color: Colors.black54)),
              ),
            ),
            Uploader(
              type: FileType.image,
              path: "projects",
              allowMultiple: true,
              getIVF: (data) {
                setState(() {
                  iv = data;
                });
              },
              ivf: iv,
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: TypeController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Projects Type',
                    hintStyle: TextStyle(color: Colors.black54)),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: YoutubeLinkController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Youtube Link',
                    hintStyle: TextStyle(color: Colors.black54)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Tags",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: TagsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(TagsList[index]),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteTags(index);
                  },
                  child: ListTile(
                    title: Text(
                      TagsList[index],
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteTags(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editTags(index);
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.move_up,
                              size: 30,
                            ),
                            onTap: () {
                              moveTagsUp(index);
                            },
                            onDoubleTap: () {
                              moveTagsDown(index);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      editTags(index);
                    },
                  ),
                );
              },
            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                    child: TextFormField(
                      controller: _TagsController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Tags Here',
                          hintStyle: TextStyle(color: Colors.black),
                          hoverColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 45,
                    ),
                  ),
                  onTap: () {
                    addTags();
                  },
                )
              ],
            ),
            TextFieldContainer(
              heading: "About Project",
              child: TextFormField(
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.black54)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Table Of Content",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tableOfContentList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(tableOfContentList[index]),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deletetableOfContent(index);
                  },
                  child: ListTile(
                    title: Text(
                      tableOfContentList[index],
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletetableOfContent(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              edittableOfContent(index);
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.move_up,
                              size: 30,
                            ),
                            onTap: () {
                              movetableOfContentUp(index);
                            },
                            onDoubleTap: () {
                              movetableOfContentDown(index);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      edittableOfContent(index);
                    },
                  ),
                );
              },
            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                    child: TextFormField(
                      controller: _tableOfContentController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter tableOfContent Here',
                          hintStyle: TextStyle(color: Colors.black),
                          hoverColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 45,
                    ),
                  ),
                  onTap: () {
                    addtableOfContent();
                  },
                )
              ],
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
                      (index) => Container(
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
                                child: Text(descriptionList[index].heading)),
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
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Text(
                      "Components And Supplies",
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
                      ComponentsAndSupplies.length,
                      (index) => Container(
                        key: ValueKey(index),
                        // Assign a unique key to each item
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: convertorForTRCSRCContainer(
                            ComponentsAndSupplies[index], 0, index),
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
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFieldContainer(
                                heading: "Heading",
                                child: TextFormField(
                                  controller: _HeadingFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Heading',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFieldContainer(
                                heading: "Type",
                                child: TextFormField(
                                  controller: _TypeFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFieldContainer(
                                heading: "Data",
                                child: TextFormField(
                                  controller: _DataFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'data',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 45,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                // ComponentsAndSupplies.add(ConvertorForTRCSRC(
                                //     heading: _HeadingFilesController.text,
                                //     image: _DataFilesController.text,
                                //     path: _TypeFilesController.text));
                                _HeadingFilesController.clear();
                                _DataFilesController.clear();
                                _TypeFilesController.clear();
                              });
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
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Text(
                      "Tools Required",
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
                      toolsRequired.length,
                      (index) => Container(
                        key: ValueKey(index),
                        // Assign a unique key to each item
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: convertorForTRCSRCContainer(
                            toolsRequired[index], 0, index),
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
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFieldContainer(
                                heading: "Heading",
                                child: TextFormField(
                                  controller: _HeadingFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Heading',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFieldContainer(
                                heading: "Type",
                                child: TextFormField(
                                  controller: _TypeFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFieldContainer(
                                heading: "Data",
                                child: TextFormField(
                                  controller: _DataFilesController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'data',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 45,
                              ),
                            ),
                            onTap: () {
                              // setState(() {
                              //   toolsRequired.add(ConvertorForTRCSRC(
                              //       heading: _HeadingFilesController.text,
                              //
                              //       path: _TypeFilesController.text, IVF: IVFUploader(type: "", file_url: "", size: "", file_messageId: 0, thumbnail_url: "", thumbnail_messageId: 0)));
                              //   _HeadingFilesController.clear();
                              //   _DataFilesController.clear();
                              //   _TypeFilesController.clear();
                              // });
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
                      (index) => Container(
                        key: ValueKey(index),
                        // Assign a unique key to each item
                        padding: EdgeInsets.symmetric(vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: convertorForTRCSRCContainer(
                            appAndPlatforms[index], 2, index),
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
                          child: TextFormField(
                            controller: Heading_ConvertorForTRCSRC_Controller,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Heading',
                                hintStyle: TextStyle(color: Colors.black)),
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Name",
                                child: TextFormField(
                                  controller:
                                      PathName_ConvertorForTRCSRC_Controller,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'name',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
                          ),
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Path Id",
                                child: TextFormField(
                                  controller:
                                      PathId_ConvertorForTRCSRC_Controller,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Id',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                )),
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
                                IVF_appAndPlatforms = IVFData.first;
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
                                              Heading_ConvertorForTRCSRC_Controller
                                                  .text,
                                          path: Path(
                                              path:
                                                  PathName_ConvertorForTRCSRC_Controller
                                                      .text,
                                              id: PathId_ConvertorForTRCSRC_Controller
                                                  .text),
                                          IVF: IVF_appAndPlatforms != null
                                              ? IVF_appAndPlatforms!
                                              : IVFUploader(
                                                  type: "",
                                                  file_url: "",
                                                  file_name: "",
                                                  size: "",
                                                  file_messageId: 0,
                                                  thumbnail_url: "",
                                                  thumbnail_messageId: 0));
                                } else
                                  appAndPlatforms.add(ConvertorForTRCSRC(
                                      heading:
                                          Heading_ConvertorForTRCSRC_Controller
                                              .text,
                                      path: Path(
                                          path:
                                              PathName_ConvertorForTRCSRC_Controller
                                                  .text,
                                          id: PathId_ConvertorForTRCSRC_Controller
                                              .text),
                                      IVF: IVF_appAndPlatforms != null
                                          ? IVF_appAndPlatforms!
                                          : IVFUploader(
                                              type: "",
                                              file_url: "",
                                              file_name: "",
                                              size: "",
                                              file_messageId: 0,
                                              thumbnail_url: "",
                                              thumbnail_messageId: 0)));
                                selectedConvertorForTRCSRC = -1;
                                IVF_appAndPlatforms = IVFUploader(
                                    type: "",
                                    file_url: "",
                                    file_name: "",
                                    size: "",
                                    file_messageId: 0,
                                    thumbnail_url: "",
                                    thumbnail_messageId: 0);
                              });

                              Heading_ConvertorForTRCSRC_Controller.clear();
                              PathName_ConvertorForTRCSRC_Controller.clear();
                              PathId_ConvertorForTRCSRC_Controller.clear();
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
                        displayHere:[],
                        thumbnail:IVFUploader(
                            type: "",
                            file_url: "",
                            file_name: "",
                            size: "",
                            file_messageId: 0,
                            thumbnail_url: "",
                            thumbnail_messageId: 0),
                        isContainsAds: isContainsAds,
                        isFree: isFree,
                        id: widget.data == null ? id : widget.data!.id,
                        type: TypeController.text,
                        youtubeUrl: YoutubeLinkController.text,
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
                        images: iv);

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

  Widget convertorForTRCSRCContainer(
      ConvertorForTRCSRC data, int mode, int index) {
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
                      "IVF : ${data.IVF.file_name}",
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
                        if (mode == 2) {
                          Heading_ConvertorForTRCSRC_Controller.text =
                              appAndPlatforms[index].heading;
                          PathName_ConvertorForTRCSRC_Controller.text =
                              appAndPlatforms[index].path.path;
                          ;
                          PathId_ConvertorForTRCSRC_Controller.text =
                              appAndPlatforms[index].path.id;
                          ;
                          IVF_appAndPlatforms = appAndPlatforms[index].IVF;
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


                          deleteFileFromTelegramBot(appAndPlatforms[index].IVF.file_messageId);
                          deleteFileFromTelegramBot(appAndPlatforms[index].IVF.thumbnail_messageId);
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
