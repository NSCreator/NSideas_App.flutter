

import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/textFeild.dart';
import 'package:path_provider/path_provider.dart';

import 'functions.dart';
import 'homePage.dart';

class SensorsCreator extends StatefulWidget {
  final String id;

  String data;
  String subData;
  String images;
  String table;
  String files;

  SensorsCreator({
    Key? key,
    required this.id,
    this.data = "",
    this.subData = "",
    this.images = "",
    this.table = "",
    this.files = "",
  }) : super(key: key);

  @override
  State<SensorsCreator> createState() => _SensorsCreatorState();
}

class _SensorsCreatorState extends State<SensorsCreator> {
  List<String> pointsList = [];
  final TextEditingController _pointsController = TextEditingController();
  int selectedPointIndex = -1;

  TextEditingController HeadingController = TextEditingController();

  List<String> ImageList = [];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  autoFill() {
    if (widget.id.isNotEmpty) {
      HeadingController.text = widget.data;
      if (widget.subData.isNotEmpty) pointsList = widget.subData.split(";");
      if (widget.images.isNotEmpty) ImageList = widget.images.split(";");
      // if (widget.files.isNotEmpty) FilesList = widget.files;
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

  void addImages() {
    String points = _ImageController.text;
    if (points.isNotEmpty) {
      setState(() {
        ImageList.add(points);
        _ImageController.clear();
      });
    }
  }

  void editImages(int index) {
    setState(() {
      selectedImageIndex = index;
      _ImageController.text = ImageList[index];
    });
  }

  void saveImages() {
    String editedImage = _ImageController.text;
    if (editedImage.isNotEmpty && selectedImageIndex != -1) {
      setState(() {
        ImageList[selectedImageIndex] = editedImage;
        _ImageController.clear();
        selectedImageIndex = -1;
      });
    }
  }

  void deleteImages(int index) {
    setState(() {
      ImageList.removeAt(index);
      if (selectedImageIndex == index) {
        selectedImageIndex = -1;
        _ImageController.clear();
      }
    });
  }

  void moveImagesUp(int index) {
    if (index > 0) {
      setState(() {
        String point = ImageList.removeAt(index);
        ImageList.insert(index - 1, point);
        if (selectedImageIndex == index) {
          selectedImageIndex--;
        }
      });
    }
  }

  void moveImagesDown(int index) {
    if (index < ImageList.length - 1) {
      setState(() {
        String Image = ImageList.removeAt(index);
        ImageList.insert(index + 1, Image);
        if (selectedImageIndex == index) {
          selectedImageIndex++;
        }
      });
    }
  }

  List<CodeFilesConvertor> filesList = [];
  final TextEditingController _HeadingFilesController = TextEditingController();
  final TextEditingController _DataFilesController = TextEditingController();
  final TextEditingController _TypeFilesController = TextEditingController();
  int selectedFilesIndex = -1;

  void addFiles() {
    setState(() {
      filesList.add(CodeFilesConvertor(
          heading: _HeadingFilesController.text,
          data: _DataFilesController.text,
          type: _TypeFilesController.text));
      _HeadingFilesController.clear();
      _DataFilesController.clear();
      _TypeFilesController.clear();
    });
  }

  void editFiles(int index) {
    setState(() {
      selectedFilesIndex = index;
      _HeadingFilesController.text = filesList[index].heading;
      _DataFilesController.text = filesList[index].data;
      _TypeFilesController.text = filesList[index].type;
    });
  }

  void saveFiles() {
    String editedHeadingFiles = _HeadingFilesController.text;
    String editedDataFiles = _DataFilesController.text;
    String editedTypeFiles = _TypeFilesController.text;
    if (editedHeadingFiles.isNotEmpty &&
        editedDataFiles.isNotEmpty &&
        editedTypeFiles.isNotEmpty &&
        selectedFilesIndex != -1) {
      setState(() {
        filesList[selectedFilesIndex].heading = editedHeadingFiles;
        filesList[selectedFilesIndex].data = editedDataFiles;
        filesList[selectedFilesIndex].type = editedTypeFiles;
        _HeadingFilesController.clear();
        _DataFilesController.clear();
        _TypeFilesController.clear();
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
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Back",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
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
              ListView.builder(
                itemCount: ImageList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(ImageList[index]),
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
                      deleteImages(index);
                    },
                    child: ListTile(
                      title: Text(ImageList[index]),
                      trailing: SingleChildScrollView(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteImages(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                editImages(index);
                              },
                            ),
                            InkWell(
                              child: Icon(
                                Icons.move_up,
                                size: 30,
                              ),
                              onTap: () {
                                moveImagesUp(index);
                              },
                              onDoubleTap: () {
                                moveImagesDown(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        editImages(index);
                      },
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFieldContainer(
                        heading: "Images",
                        child: TextFormField(
                          controller: _ImageController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Images',
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
                      addImages();
                    },
                  )
                ],
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
                    key: Key(filesList[index].data),
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
                      deleteImages(index);
                    },
                    child: ListTile(
                      leading: Text(filesList[index].type),
                      title: Text(filesList[index].heading),
                      subtitle: Text(filesList[index].data),
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
                              controller: _TypeFilesController,
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
                              controller: _DataFilesController,
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
                              .collection('others')
                              .doc("arduinoBoards")
                              .collection("boards")
                              .doc(widget.id)
                              .update({
                            'descriptions': FieldValue.arrayUnion([
                              DescriptionConvertor(
                                heading: HeadingController.text,
                                points: pointsList,
                                images: ImageList,
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


class sensorsAndComponents extends StatefulWidget {
  const sensorsAndComponents({Key? key}) : super(key: key);

  @override
  State<sensorsAndComponents> createState() => _sensorsAndComponentsState();
}

class _sensorsAndComponentsState extends State<sensorsAndComponents> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Padding(
            padding:  EdgeInsets.only(left: 15,bottom: 15),
            child: Text(
              "Sensors",
              style: TextStyle(color: Colors.white, fontSize:20),
            ),
          ),
          StreamBuilder<List<sensorsConvertor>>(
            stream: readsensors(),
            builder: (context, snapshot) {
              final Subjects = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ));
                default:
                  if (snapshot.hasError) {
                    return const Text("Error with server");
                  } else {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: Subjects!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];

                        return InkWell(
                          child: Padding(
                            padding:  EdgeInsets.only(
                                left: 10, right: 10, bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius:  BorderRadius.all(
                                    Radius.circular(15)
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    child: ImageShowAndDownload(
                                      image: SubjectsData.photoUrl.split(";").first,
                                      id: SubjectsData.id,
                                    ),
                                    height: 70,
                                    width: 110,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.all(8.0),
                                        child: Text(
                                          SubjectsData.name,
                                          style:  TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("sensors")
                                .doc(SubjectsData
                                .id) // Replace "documentId" with the ID of the document you want to retrieve
                                .get()
                                .then((DocumentSnapshot snapshot) async {
                              if (snapshot.exists) {
                                var data = snapshot.data();
                                if (data != null &&
                                    data is Map<String, dynamic>) {
                                  List<String> images = [];
                                  images = SubjectsData.photoUrl.split(";");
                                  images.addAll(
                                      data['pinDiagram'].toString().split(";"));


                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                          sensor(
                                            pinDiagram: data['pinDiagram'],
                                            id: SubjectsData.id,
                                            name: SubjectsData.name,
                                            description: data['description'],
                                            photoUrl: SubjectsData.photoUrl,
                                            pinConnection: data['pinConnection'],
                                            technicalParameters: data['technicalParameters'],
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color: Colors.black
                                              .withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration:
                                              Duration(milliseconds: 300),
                                              opacity: animation.value
                                                  .clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                print("Document does not exist.");
                              }
                            }).catchError((error) {
                              print(
                                  "An error occurred while retrieving data: $error");
                            });
                          },
                        );
                      },
                    );
                  }
              }
            },
          ),
          SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}
class sensor extends StatefulWidget {
  String description,photoUrl,name,id,technicalParameters,pinDiagram,pinConnection;

  sensor({Key? key, required this.description,required this.photoUrl,required this.id,required this.name,required this.pinConnection,required this.pinDiagram,required this.technicalParameters}) : super(key: key);

  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {
  List images = [];
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;

  @override
  void initState() {
    super.initState();
    images = widget.photoUrl.split(",");
  }

  @override
  Widget build(BuildContext context) {

    return backGroundImage(
        text: widget.name,
        child:    Column(

          children: [
            scrollingImages(
              images: images, id: widget.id,isZoom: true,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(color: Colors.orangeAccent),
                    child: Center(
                      child: Text(
                        "About Sensor",
                        style:  TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    child: Text(
                      "          ${widget.description}",
                      style:  TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding:  EdgeInsets.all(3.0),
                    decoration: BoxDecoration(color: Colors.orangeAccent),
                    child: Center(
                      child: Text(
                        "Technical Parameters",
                        style:  TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.technicalParameters
                            .split(";")
                            .length +
                            1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Table(
                              border: TableBorder.all(
                                  width: 0.8,
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.only(
                                          topRight: Radius
                                              .circular(10),
                                          topLeft: Radius
                                              .circular(
                                              10)),
                                      color:
                                      Colors.grey.withOpacity(0.3)),
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Technical Parameters',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Description',
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
                            String subTechnicalParameters = widget
                                .technicalParameters
                                .split(";")[index - 1];
                            return Table(
                              border: TableBorder.all(
                                  width: 0.5,
                                  color: Colors.white54,
                                  borderRadius: index ==
                                      widget.technicalParameters
                                          .split(";")
                                          .length
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight:
                                      Radius.circular(10))
                                      : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.all(8.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          subTechnicalParameters
                                              .split(":")
                                              .first,
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.all(8.0),
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters
                                                .split(":")
                                                .last,
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      )),

                  if (widget.pinDiagram.isNotEmpty)
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "PinOut",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Container(
                              height: 2,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          scrollingImages(
                            images: widget.pinDiagram.split(";"), id: widget.id,isZoom: true,
                          ),
                        ],
                      ),
                    ),
                  Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 50),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                        widget.pinConnection.split(";").length +
                            1, // Number of rows including the header
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Text(
                                  "Pin Connections",
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    height: 2,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                  ),
                                ),
                                Table(
                                  border: TableBorder.all(
                                      width: 0.8,
                                      color: Colors.white70,

                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: FractionColumnWidth(0.5),
                                    1: FractionColumnWidth(0.5),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withOpacity(0.3)),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Module',
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
                                            'Uno',
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
                                ),
                              ],
                            );
                          } else {
                            String subTechnicalParameters = widget
                                .pinConnection
                                .split(";")[index - 1];
                            return Table(
                              border: TableBorder.all(
                                  width: 0.5,
                                  color: Colors.white54,
                                  borderRadius: index ==
                                      widget.pinConnection
                                          .split(";")
                                          .length
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight:
                                      Radius.circular(10))
                                      : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          subTechnicalParameters
                                              .split(":")
                                              .first,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            subTechnicalParameters
                                                .split(":")
                                                .last,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
            Description(id: '', data: [],),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}

class sensorsConvertor {
  String id;
  final String name,
      photoUrl;


  sensorsConvertor(
      {this.id = "",
        required this.name,
        required this.photoUrl,});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photoUrl": photoUrl,

  };

  static sensorsConvertor fromJson(Map<String, dynamic> json) =>
      sensorsConvertor(
        id: json['id'],
        name: json["name"],
        photoUrl: json["photoUrl"],
      );
}
Stream<List<sensorsConvertor>> readsensors() => FirebaseFirestore.instance
    .collection('sensors')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => sensorsConvertor.fromJson(doc.data()))
    .toList());
