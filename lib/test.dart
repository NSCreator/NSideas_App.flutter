// @immutable
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/projects.dart';
import 'textFeild.dart';
import 'package:path_provider/path_provider.dart';

import 'functions.dart';
import 'homePage.dart';

class SensorsCreator extends StatefulWidget {


  SensorsCreator() ;

  @override
  State<SensorsCreator> createState() => _SensorsCreatorState();
}

class _SensorsCreatorState extends State<SensorsCreator> {
  List<String> pinDiagramsList = [];
  final TextEditingController _pinDiagramController = TextEditingController();
  int selectedPointIndex = -1;

  TextEditingController ShortHeadingController = TextEditingController();
  TextEditingController FullHeadingController = TextEditingController();
  TextEditingController AboutHeadingController = TextEditingController();
  TextEditingController TypeController = TextEditingController();

  List<String> ImageList = ["dd"];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  autoFill() {}

  void addPinDiagrams() {
    String pinDiagrams = _pinDiagramController.text;
    if (pinDiagrams.isNotEmpty) {
      setState(() {
        pinDiagramsList.add(pinDiagrams);
        _pinDiagramController.clear();
      });
    }
  }

  void editPinDiagrams(int index) {
    setState(() {
      selectedPointIndex = index;
      _pinDiagramController.text = pinDiagramsList[index];
    });
  }

  void savePinDiagrams() {
    String editedPoint = _pinDiagramController.text;
    if (editedPoint.isNotEmpty && selectedPointIndex != -1) {
      setState(() {
        pinDiagramsList[selectedPointIndex] = editedPoint;
        _pinDiagramController.clear();
        selectedPointIndex = -1;
      });
    }
  }

  void deletePinDiagrams(int index) {
    setState(() {
      pinDiagramsList.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        _pinDiagramController.clear();
      }
    });
  }

  void movePinDiagramUp(int index) {
    if (index > 0) {
      setState(() {
        String point = pinDiagramsList.removeAt(index);
        pinDiagramsList.insert(index - 1, point);
        if (selectedPointIndex == index) {
          selectedPointIndex--;
        }
      });
    }
  }

  void movePinDiagramDown(int index) {
    if (index < pinDiagramsList.length - 1) {
      setState(() {
        String point = pinDiagramsList.removeAt(index);
        pinDiagramsList.insert(index + 1, point);
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

  List<TableConvertor> pinConnectionsList = [];
  TextEditingController col0pinConnectionsController = TextEditingController();
  TextEditingController col1pinConnectionsController = TextEditingController();
  int selectedpinConnectionsIndex = -1;

  void addpinConnections() {
    setState(() {
      pinConnectionsList.add(
          TableConvertor(col0: col0pinConnectionsController.text, col1: col1pinConnectionsController.text));
      col0pinConnectionsController.clear();
      col1pinConnectionsController.clear();
    });
  }

  void editpinConnections(int index) {
    TableConvertor selectedPoint = pinConnectionsList[index];
    setState(() {
      selectedpinConnectionsIndex = index;
      col0pinConnectionsController.text = selectedPoint.col0;
      col1pinConnectionsController.text = selectedPoint.col1;
    });
  }

  void savepinConnections() {
    String newName = col0pinConnectionsController.text;
    String newScoreText = col1pinConnectionsController.text;

    if (newName.isNotEmpty &&
        newScoreText.isNotEmpty &&
        selectedpinConnectionsIndex != -1) {
      TableConvertor selectedPoint = pinConnectionsList[selectedpinConnectionsIndex];
      setState(() {
        selectedPoint.col0 = newName;
        selectedPoint.col1 = newScoreText;
        selectedpinConnectionsIndex = -1;
        col0pinConnectionsController.clear();
        col1pinConnectionsController.clear();
      });
    }
  }

  void deletepinConnections(int index) {
    setState(() {
      pinConnectionsList.removeAt(index);
      if (selectedpinConnectionsIndex == index) {
        selectedpinConnectionsIndex = -1;
        col0pinConnectionsController.clear();
        col1pinConnectionsController.clear();
      }
    });
  }

  void movepinConnectionsUp(int index) {
    if (index > 0) {
      setState(() {
        TableConvertor currentPoint = pinConnectionsList[index];
        pinConnectionsList.removeAt(index);
        pinConnectionsList.insert(index - 1, currentPoint);
      });
    }
  }

  void movepinConnectionsDown(int index) {
    if (index < pinConnectionsList.length - 1) {
      setState(() {
        TableConvertor currentPoint = pinConnectionsList[index];
        pinConnectionsList.removeAt(index);
        pinConnectionsList.insert(index + 1, currentPoint);
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: []),
                child: Column(
                  children: [
                    TextFieldContainer(
                        heading: "Short",
                        child: TextFormField(
                          controller: ShortHeadingController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'short',
                              hintStyle: TextStyle(color: Colors.black)),
                        )),
                    TextFieldContainer(
                        heading: "Full",
                        child: TextFormField(
                          controller: FullHeadingController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Full',
                              hintStyle: TextStyle(color: Colors.black)),
                        ))
                  ],
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
              TextFieldContainer(
                  heading: "About",
                  child: TextFormField(
                    controller: AboutHeadingController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'About',
                        hintStyle: TextStyle(color: Colors.black)),
                  )),
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
                              col0pinConnectionsController.clear();
                              col1pinConnectionsController.clear();
                            },
                          ))
                    ],
                  ),
                ],
              ),

              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: pinDiagramsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(pinDiagramsList[index]),
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
                      deletePinDiagrams(index);
                    },
                    child: ListTile(
                      title: selectedPointIndex == index
                          ? TextField(
                              textInputAction: TextInputAction.done,
                              maxLines: null,
                              controller: _pinDiagramController,
                              onEditingComplete: savePinDiagrams,
                            )
                          : Text(pinDiagramsList[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletePinDiagrams(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editPinDiagrams(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_upward),
                            onPressed: () {
                              movePinDiagramUp(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () {
                              movePinDiagramDown(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        editPinDiagrams(index);
                      },
                    ),
                  );
                },
              ),
              Row(

                children: [
                  Flexible(
                    child:
                    TextFieldContainer(
                        heading: "Pin Diagrams",
                        child: TextFormField(
                          controller: _pinDiagramController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Url Here',
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
                      addPinDiagrams();
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
                itemCount: pinConnectionsList.length + 1,
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
                    TableConvertor point = pinConnectionsList[dataIndex];
                    return Table(
                      border: TableBorder.all(
                        width: 0.5,
                        color: Colors.white54,
                        borderRadius: dataIndex == pinConnectionsList.length - 1
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
                                        editpinConnections(dataIndex);
                                      },
                                      onDoubleTap: () {
                                        deletepinConnections(dataIndex);
                                      },
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.move_up,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        movepinConnectionsUp(dataIndex);
                                      },
                                      onDoubleTap: () {
                                        movepinConnectionsDown(dataIndex);
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
                              controller: col0pinConnectionsController,
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
                              controller: col1pinConnectionsController,
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
                                  ? savepinConnections()
                                  : addpinConnections();
                              col0pinConnectionsController.clear();
                              col1pinConnectionsController.clear();
                            },
                          ))
                    ],
                  ),
                ],
              ),
              TextFieldContainer(
                  heading: "Type",
                  child: TextFormField(
                    controller: TypeController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Type Here',
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
                              .collection('sensors')
                              .doc(id)
                              .set(SensorsConverter(
                            id: id,
                            heading: HeadingConvertor(
                              full: FullHeadingController.text,
                              short: ShortHeadingController.text,
                            ),
                            images: ImageList,
                            about: AboutHeadingController.text,
                            pinDiagrams: pinDiagramsList,
                            descriptions: [], technicalParameters:tableList , pinConnections: pinConnectionsList, type: TypeController.text,
                          ).toJson());
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
  List<SensorsConverter> sensors;
   sensorsAndComponents({required this.sensors});

  @override
  State<sensorsAndComponents> createState() => _sensorsAndComponentsState();
}

class _sensorsAndComponentsState extends State<sensorsAndComponents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15,top: 10),
                child: Text(
                  "Sensors",
                  style: TextStyle( fontSize: 20,fontWeight: FontWeight.w500),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.sensors!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final SubjectsData = widget.sensors[index];

                  return InkWell(
                    child: Container(
                      margin:
                      EdgeInsets.only(left: 15, right: 5, bottom: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius:
                        BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          if(SubjectsData.images
                              .first.isNotEmpty)Container(
                            child: ImageShowAndDownload(
                              image: SubjectsData.images
                                  .first,
                              id: SubjectsData.id,
                            ),
                            height: 70,
                            width: 100,
                          ),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.08)),
                                child: Text(
                                  SubjectsData.heading.full,
                                  style: TextStyle(
                                    fontSize: 20, ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                          const Duration(milliseconds: 300),
                          pageBuilder: (context, animation,
                              secondaryAnimation) =>
                              sensor(data: SubjectsData,
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
                    },
                  );
                },
              ),

              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class sensor extends StatefulWidget {
  SensorsConverter data;

  sensor(
      {Key? key,
      required this.data})
      : super(key: key);

  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {

  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                scrollingImages(
                  images: widget.data.images,
                  id: widget.data.id,
                  isZoom: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8, top: 20),
                  child: Column(
                    children: [
                      HeadingWithDivider(heading:"About Sensor" ,),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "          ${widget.data.about}",
                          style: TextStyle( fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Column(
                    children: [
                      HeadingWithDivider(heading:"Technical Parameters" ,),


                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.technicalParameters
                                .length, // Number of rows including the header
                            itemBuilder: (context, index) {
                              TableConvertor subTechnicalParameters =widget.data.technicalParameters[index];
                              return Table(
                                border: TableBorder.all(
                                    width: 0.5,
                                    color: Colors.white60,
                                    borderRadius: index == 0
                                        ? BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))
                                        : index == widget.data.technicalParameters.length - 1
                                        ? BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))
                                        : BorderRadius.circular(0)),
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FractionColumnWidth(0.4),
                                  1: FractionColumnWidth(0.5),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters.col0,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              subTechnicalParameters.col1,
                                              style:
                                              TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (widget.data.pinDiagrams.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              HeadingWithDivider(heading:"Pin Connections" ,),
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
                                images: widget.data.pinDiagrams,
                                id: widget.data.id,
                                isZoom: true,
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.pinConnections
                                .length, // Number of rows including the header
                            itemBuilder: (context, index) {
                              TableConvertor subTechnicalParameters =
                              widget.data.pinConnections[index];
                              return Table(
                                border: TableBorder.all(
                                    width: 0.5,
                                    color: Colors.white60,
                                    borderRadius: index == 0
                                        ? BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))
                                        : index == widget.data.pinConnections.length - 1
                                        ? BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))
                                        : BorderRadius.circular(0)),
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FractionColumnWidth(0.4),
                                  1: FractionColumnWidth(0.5),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters.col0,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              subTechnicalParameters.col1,
                                              style:
                                              TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Description(
                  id: '',
                  data: [],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }
}
class HeadingWithDivider extends StatelessWidget {
  String heading;
   HeadingWithDivider({required this.heading,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Center(
          child: Text(
            "  $heading  ",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}


class SensorsConverter {
  final String id,type;
  final HeadingConvertor heading;
  final String about;
  final List<TableConvertor> technicalParameters, pinConnections;
  final List<String> images, pinDiagrams;
  final List<DescriptionConvertor> descriptions;

  SensorsConverter({
    this.id = "",
    required this.heading,
    required this.type,
    required this.images,
    required this.descriptions,
    required this.about,
    required this.pinDiagrams,
    required this.technicalParameters,
    required this.pinConnections,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'heading': heading.toJson(),
    'images': images,
    'type': type,
    'descriptions': descriptions.map((desc) => desc.toJson()).toList(),
    'about': about,
    'pinDiagrams': pinDiagrams,
    'technicalParameters':
    technicalParameters.map((table) => table.toJson()).toList(),
    'pinConnections':
    pinConnections.map((table) => table.toJson()).toList(),
  };

  static SensorsConverter fromJson(Map<String, dynamic> json) => SensorsConverter(
    id: json['id'] ?? "",
    descriptions: DescriptionConvertor.fromMapList(json['descriptions'] ?? []),
    heading: HeadingConvertor.fromJson(json["heading"]),
    images: List<String>.from(json["images"]),
    about: json["about"],
    type: json["type"],
    pinDiagrams: List<String>.from(json["pinDiagrams"]),
    technicalParameters: TableConvertor.fromMapList(json['technicalParameters'] ?? []),
    pinConnections: TableConvertor.fromMapList(json['pinConnections'] ?? []),
  );

  static List<SensorsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}


Stream<List<SensorsConverter>> readsensors() => FirebaseFirestore.instance
    .collection('sensors')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => SensorsConverter.fromJson(doc.data()))
        .toList());
