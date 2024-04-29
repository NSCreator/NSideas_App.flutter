import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/converter.dart';

import '../functions.dart';
import '../test1.dart';
import '../textFeild.dart';


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

  List<String> ImageList = [];


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
              // Uploader(
              //   onChanged: (value) {
              //
              //     setState(() {
              //       ImageList= value;
              //     });
              //
              //   }, type: FileType.image,
              //   allowMultiple: true,
              // ),
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



