import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import 'board/converter.dart';
import 'functions.dart';

class DescriptionCreator extends StatefulWidget {
  final String id;
  final String mode;

  DescriptionConvertor? data;

  DescriptionCreator({
    this.data,
    required this.id,
    required this.mode,
  });

  @override
  State<DescriptionCreator> createState() => _DescriptionCreatorState();
}

class _DescriptionCreatorState extends State<DescriptionCreator> {
  List<String> pointsList = [];
  final TextEditingController _pointsController = TextEditingController();
  int selectedPointIndex = -1;

  TextEditingController HeadingController = TextEditingController();

  List<IVFUploader> ImageList = [];

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  autoFill() {
    if (widget.data != null) {
      HeadingController.text = widget.data!.heading;
      pointsList = widget.data!.points;
      ImageList = widget.data!.IVF;
      filesList = widget.data!.files;
      tableList = widget.data!.table;
    }
  }

  void addTextField() {
    String points = _pointsController.text;
    if (points.isNotEmpty) {
      setState(() {
        pointsList.add(points);
        _pointsController.clear();
      });
    }
  }

  void editPoint(int index) {
    setState(() {
      selectedPointIndex = index;
      _pointsController.text = pointsList[index];
    });
  }

  void saveEditedPoint() {
    String editedPoint = _pointsController.text;
    if (editedPoint.isNotEmpty && selectedPointIndex != -1) {
      setState(() {
        pointsList[selectedPointIndex] = editedPoint;
        _pointsController.clear();
        selectedPointIndex = -1;
      });
    }
  }

  void deletePoint(int index) {
    setState(() {
      pointsList.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        _pointsController.clear();
      }
    });
  }

  void movePointUp(int index) {
    if (index > 0) {
      setState(() {
        String point = pointsList.removeAt(index);
        pointsList.insert(index - 1, point);
        if (selectedPointIndex == index) {
          selectedPointIndex--;
        }
      });
    }
  }

  void movePointDown(int index) {
    if (index < pointsList.length - 1) {
      setState(() {
        String point = pointsList.removeAt(index);
        pointsList.insert(index + 1, point);
        if (selectedPointIndex == index) {
          selectedPointIndex++;
        }
      });
    }
  }

  List<TableConvertor> tableList = [];
  TextEditingController col0Controller = TextEditingController();
  TextEditingController col1Controller = TextEditingController();
  int selectedTableIndex = -1;

  void addTable() {
    setState(() {
      tableList.add(
          TableConvertor(col0: col0Controller.text, col1: col1Controller.text));
      col0Controller.clear();
      col1Controller.clear();
    });
  }

  void editTable(int index) {
    TableConvertor selectedPoint = tableList[index];
    setState(() {
      selectedPointIndex = index;
      col0Controller.text = selectedPoint.col0;
      col1Controller.text = selectedPoint.col1;
    });
  }

  void saveEditedTable() {
    String newName = col0Controller.text;
    String newScoreText = col1Controller.text;

    if (newName.isNotEmpty &&
        newScoreText.isNotEmpty &&
        selectedPointIndex != -1) {
      TableConvertor selectedPoint = tableList[selectedPointIndex];
      setState(() {
        selectedPoint.col0 = newName;
        selectedPoint.col1 = newScoreText;
        selectedPointIndex = -1;
        col0Controller.clear();
        col1Controller.clear();
      });
    }
  }

  void deleteTable(int index) {
    setState(() {
      tableList.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        col0Controller.clear();
        col1Controller.clear();
      }
    });
  }

  void moveTableUp(int index) {
    if (index > 0) {
      setState(() {
        TableConvertor currentPoint = tableList[index];
        tableList.removeAt(index);
        tableList.insert(index - 1, currentPoint);
      });
    }
  }

  void moveTableDown(int index) {
    if (index < tableList.length - 1) {
      setState(() {
        TableConvertor currentPoint = tableList[index];
        tableList.removeAt(index);
        tableList.insert(index + 1, currentPoint);
      });
    }
  }

  List<CodeFilesConvertor> filesList = [];
  final TextEditingController _HeadingFilesController = TextEditingController();
  final TextEditingController _CodeController = TextEditingController();
  final TextEditingController _CodeLangController = TextEditingController();
  int selectedFilesIndex = -1;

  void addFiles() {
    setState(() {
      filesList.add(CodeFilesConvertor(
          heading: _HeadingFilesController.text,
          code: _CodeController.text,
          lang: _CodeLangController.text,
          IVF: IVFUploader(
              type: "",
              file_url: "",
              size: "",
              file_messageId: 0,
              thumbnail_url: "",
              thumbnail_messageId: 0, file_name: '')));
      _HeadingFilesController.clear();
      _CodeController.clear();
      _CodeLangController.clear();
    });
  }

  void editFiles(int index) {
    setState(() {
      selectedFilesIndex = index;
      _HeadingFilesController.text = filesList[index].heading;
      _CodeController.text = filesList[index].code;
      _CodeLangController.text = filesList[index].lang;
    });
  }

  void saveFiles() {
    String editedHeadingFiles = _HeadingFilesController.text;
    String editedDataFiles = _CodeController.text;
    String editedTypeFiles = _CodeLangController.text;
    if (editedHeadingFiles.isNotEmpty &&
        editedDataFiles.isNotEmpty &&
        editedTypeFiles.isNotEmpty &&
        selectedFilesIndex != -1) {
      setState(() {
        filesList[selectedFilesIndex].heading = editedHeadingFiles;
        filesList[selectedFilesIndex].code = editedDataFiles;
        filesList[selectedFilesIndex].lang = editedTypeFiles;
        _HeadingFilesController.clear();
        _CodeController.clear();
        _CodeLangController.clear();
        selectedFilesIndex = -1;
      });
    }
  }

  void deleteFiles(int index) {
    setState(() {
      filesList.removeAt(index);
      if (selectedFilesIndex == index) {
        selectedFilesIndex = -1;
      }
    });
  }

  void moveFilesUp(int index) {
    if (index > 0) {
      setState(() {
        CodeFilesConvertor files = filesList.removeAt(index);
        filesList.insert(index - 1, files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex--;
        }
      });
    }
  }

  void moveFilesDown(int index) {
    if (index < filesList.length - 1) {
      setState(() {
        CodeFilesConvertor files = filesList.removeAt(index);
        filesList.insert(index + 1, files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex++;
        }
      });
    }
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
              backButton(),
              TextFieldContainer(
                  heading: "Heading",
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Heading',
                        hintStyle: TextStyle(color: Colors.black)),
                  )),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: pointsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(pointsList[index]),
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
                      deletePoint(index);
                    },
                    child: ListTile(
                      title: selectedPointIndex == index
                          ? TextField(
                              textInputAction: TextInputAction.done,
                              maxLines: null,
                              controller: _pointsController,
                              onEditingComplete: saveEditedPoint,
                            )
                          : Text(pointsList[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletePoint(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editPoint(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_upward),
                            onPressed: () {
                              movePointUp(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () {
                              movePointDown(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        editPoint(index);
                      },
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFieldContainer(
                        heading: "Points",
                        child: TextFormField(
                          controller: _pointsController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Points Here',
                              hintStyle: TextStyle(color: Colors.black)),
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
                      addTextField();
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tableList.length + 1,
                // Number of rows including the header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Table(
                      border: TableBorder.all(
                        width: 0.8,
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.2),
                        1: FractionColumnWidth(0.6),
                        2: FractionColumnWidth(0.2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Score',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Actions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    int dataIndex = index - 1;
                    TableConvertor point = tableList[dataIndex];
                    return Table(
                      border: TableBorder.all(
                        width: 0.5,
                        color: Colors.white54,
                        borderRadius: dataIndex == tableList.length - 1
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )
                            : BorderRadius.circular(0),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.2),
                        1: FractionColumnWidth(0.6),
                        2: FractionColumnWidth(0.2),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  point.col0,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  point.col1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Icon(
                                        Icons.published_with_changes,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        editTable(dataIndex);
                                      },
                                      onDoubleTap: () {
                                        deleteTable(dataIndex);
                                      },
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.move_up,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        moveTableUp(dataIndex);
                                      },
                                      onDoubleTap: () {
                                        moveTableDown(dataIndex);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFieldContainer(
                            heading: "Col 0",
                            child: TextFormField(
                              controller: col0Controller,
                              maxLines: null,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Col 0',
                                  hintStyle: TextStyle(color: Colors.black)),
                            )),
                      ),
                      Flexible(
                        flex: 6,
                        child: TextFieldContainer(
                            heading: "Col 1",
                            child: TextFormField(
                              controller: col1Controller,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Col 1',
                                  hintStyle: TextStyle(color: Colors.black)),
                            )),
                      ),
                      Flexible(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                selectedPointIndex != -1
                                    ? Icons.save
                                    : Icons.add,
                                size: 45,
                              ),
                            ),
                            onTap: () {
                              selectedPointIndex != -1
                                  ? saveEditedTable()
                                  : addTable();
                              col0Controller.clear();
                              col1Controller.clear();
                            },
                          ))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Text(
                  "Images",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Uploader(
                ivf: ImageList,
                getIVF: (imageData) {
                  ImageList = imageData;
                },
                type: FileType.image,
                path: "description",
                allowMultiple: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Text(
                  "Files",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              ListView.builder(
                itemCount: filesList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(filesList[index].code),
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
                      // deleteImages(index);
                    },
                    child: ListTile(
                      leading: Text(filesList[index].lang),
                      title: Text(filesList[index].heading),
                      subtitle: Text(filesList[index].code),
                      trailing: SingleChildScrollView(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteFiles(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                editFiles(index);
                              },
                            ),
                            InkWell(
                              child: Icon(
                                Icons.move_up,
                                size: 30,
                              ),
                              onTap: () {
                                moveFilesUp(index);
                              },
                              onDoubleTap: () {
                                moveFilesDown(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        editFiles(index);
                      },
                    ),
                  );
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
                                  hintStyle: TextStyle(color: Colors.black)),
                            )),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextFieldContainer(
                            heading: "Type",
                            child: TextFormField(
                              controller: _CodeLangController,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type',
                                  hintStyle: TextStyle(color: Colors.black)),
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
                              controller: _CodeController,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'data',
                                  hintStyle: TextStyle(color: Colors.black)),
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
                          addFiles();
                        },
                      )
                    ],
                  ),
                ],
              ),
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
                          await FirebaseFirestore.instance
                              .collection(widget.mode)
                              .doc(widget.id)
                              .update({
                            'descriptions': FieldValue.arrayUnion([
                              DescriptionConvertor(
                                heading: HeadingController.text,
                                points: pointsList,
                                IVF: ImageList,
                                files: filesList,
                                table: tableList,
                              ).toJson(),
                            ]),
                          });

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

class TableConvertor {
  String col0;
  String col1;

  TableConvertor({required this.col0, required this.col1});

  Map<String, dynamic> toJson() => {
        "col0": col0,
        "col1": col1,
      };

  static TableConvertor fromJson(Map<String, dynamic> json) => TableConvertor(
        col0: json['col0'] ?? "",
        col1: json["col1"] ?? "",
      );

  static List<TableConvertor> fromMapList(List<dynamic> list) {
    return list
        .map((item) => TableConvertor.fromJson(item))
        .toList(); // Change here
  }
}

class CodeFilesConvertor {
  String heading, lang;
  String code;
  final IVFUploader IVF;

  CodeFilesConvertor(
      {required this.heading,
      required this.code,
      required this.IVF,
      required this.lang});

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "code": code,
        "lang": lang,
        "IVF": IVF.toJson(),
      };

  static CodeFilesConvertor fromJson(Map<String, dynamic> json) =>
      CodeFilesConvertor(
        heading: json['heading'] ?? "",
        code: json["code"] ?? "",
        lang: json["lang"] ?? "",
        IVF: IVFUploader.fromJson(json["IVF"] ?? {}),
      );

  static List<CodeFilesConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
