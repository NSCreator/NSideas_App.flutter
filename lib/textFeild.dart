import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/projects.dart';

import 'functions.dart';
import 'homePage.dart';

class DescriptionCreator extends StatefulWidget {
  final String id;

  String data;
  String subData;
  String images;
  String table;
  String files;

  DescriptionCreator({
    Key? key,

    required this.id,

    this.data = "",
    this.subData = "",
    this.images = "",
    this.table = "",
    this.files = "",
  }) : super(key: key);

  @override
  State<DescriptionCreator> createState() => _DescriptionCreatorState();
}
class _DescriptionCreatorState extends State<DescriptionCreator> {
  List<String> pointsList = [];
  final TextEditingController _pointsController = TextEditingController();
  int selectedPointIndex = -1;

  List<TableConvertor> points = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  int selectedTableIndex = -1;

  TextEditingController HeadingController = TextEditingController();

  List<String> ImageList = [];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  List<String> FilesList = [];
  final TextEditingController _FilesController = TextEditingController();
  int selectedFilesIndex = -1;

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
      if (widget.files.isNotEmpty) FilesList = widget.files.split(";");
      if (widget.table.isNotEmpty) parsePointsString(widget.table);
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

  void parsePointsString(String pointsString) {
    List<String> pointStrings = pointsString.split(';');
    List<TableConvertor> parsedPoints = [];
    for (String pointString in pointStrings) {
      List<String> parts = pointString.split(':');
      if (parts.length == 2) {
        parsedPoints.add(TableConvertor(name: parts[0], description: parts[1]));
      }
    }
    setState(() {
      points = parsedPoints;
    });
  }

  void addTable() {
    String name = nameController.text;
    String scoreText = scoreController.text;
    String score = scoreText;

    if (name.isNotEmpty && score.isNotEmpty) {
      setState(() {
        TableConvertor newPoint = TableConvertor(name: name, description: score);
        points.add(newPoint);
        nameController.clear();
        scoreController.clear();
      });
    }
  }

  void editTable(int index) {
    TableConvertor selectedPoint = points[index];
    setState(() {
      selectedPointIndex = index;
      nameController.text = selectedPoint.name;
      scoreController.text = selectedPoint.description.toString();
    });
  }

  void saveEditedTable() {
    String newName = nameController.text;
    String newScoreText = scoreController.text;
    String newScore = newScoreText;

    if (newName.isNotEmpty && newScore.isNotEmpty && selectedPointIndex != -1) {
      setState(() {
        TableConvertor selectedPoint = points[selectedPointIndex];
        selectedPoint.name = newName;
        selectedPoint.description = newScore;
        selectedPointIndex = -1;
        nameController.clear();
        scoreController.clear();
      });
    }
  }

  void deleteTable(int index) {
    setState(() {
      points.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        nameController.clear();
        scoreController.clear();
      }
    });
  }

  void moveTableUp(int index) {
    if (index > 0) {
      setState(() {
        TableConvertor currentPoint = points[index];
        points.removeAt(index);
        points.insert(index - 1, currentPoint);
      });
    }
  }

  void moveTableDown(int index) {
    if (index < points.length - 1) {
      setState(() {
        TableConvertor currentPoint = points[index];
        points.removeAt(index);
        points.insert(index + 1, currentPoint);
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

  void addFiles() {
    String Files = _FilesController.text;
    if (Files.isNotEmpty) {
      setState(() {
        FilesList.add(Files);
        _FilesController.clear();
      });
    }
  }

  void editFiles(int index) {
    setState(() {
      selectedFilesIndex = index;
      _FilesController.text = FilesList[index];
    });
  }

  void saveFiles() {
    String editedFiles = _FilesController.text;
    if (editedFiles.isNotEmpty && selectedFilesIndex != -1) {
      setState(() {
        FilesList[selectedFilesIndex] = editedFiles;
        _FilesController.clear();
        selectedFilesIndex = -1;
      });
    }
  }

  void deleteFiles(int index) {
    setState(() {
      FilesList.removeAt(index);
      if (selectedFilesIndex == index) {
        selectedFilesIndex = -1;
        _FilesController.clear();
      }
    });
  }

  void moveFilesUp(int index) {
    if (index > 0) {
      setState(() {
        String Files = FilesList.removeAt(index);
        FilesList.insert(index - 1, Files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex--;
        }
      });
    }
  }

  void moveFilesDown(int index) {
    if (index < FilesList.length - 1) {
      setState(() {
        String Files = FilesList.removeAt(index);
        FilesList.insert(index + 1, Files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(text: "Description",),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "ParaGraph",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  controller: HeadingController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  maxLines: null,
                  // Allows the field to expand as needed
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    hintText: 'Heading',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Points",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
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
                    color: Colors.white,
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _pointsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Points Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
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
            itemCount: points.length + 1,
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
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                TableConvertor point = points[dataIndex];
                return Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Colors.white54,
                    borderRadius: dataIndex == points.length - 1
                        ? BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                        : BorderRadius.circular(0),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                              point.name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              point.description,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            maxLines: null,
                            // Allows the field to expand as needed
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              hintText: 'Parameters',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: scoreController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              // Allows the field to expand as needed
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                hintText: 'Description',
                              ),
                            ),
                          ),
                        ),
                      ),
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
                            nameController.clear();
                            scoreController.clear();
                          },
                        ))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Images",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _ImageController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
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
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            itemCount: FilesList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(FilesList[index]),
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
                  title: Text(FilesList[index]),
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
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _FilesController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Files Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
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
                  addFiles();
                },
              )
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
                          .collection('projects')
                          .doc(widget.id)
                          .update({
                        'descriptions': FieldValue.arrayUnion([
                          DescriptionConvertor(
                            id: getID(),
                             data:  HeadingController.text, subData: pointsList, images: ImageList, files: FilesList, table: points,
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
                        child:
                        Text(widget.id.isNotEmpty ? "Update" : "Create"),
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
    ),);
  }
}
class TableConvertor {
  String name;
  String description;
  TableConvertor({required this.name, required this.description});
  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,

  };

  static TableConvertor fromJson(Map<String, dynamic> json) =>
      TableConvertor(
        name: json['name'],
        description: json["description"],
         );
  static List<TableConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
