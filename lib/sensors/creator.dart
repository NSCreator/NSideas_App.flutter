import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/converter.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:nsideas/test.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

import '../functions.dart';
import '../test1.dart';
import '../textFeild.dart';

class SensorsCreator extends StatefulWidget {
  SensorsConverter? data;
  SensorsCreator({this.data});

  @override
  State<SensorsCreator> createState() => _SensorsCreatorState();
}

class _SensorsCreatorState extends State<SensorsCreator> {
  TextEditingController ShortHeadingController = TextEditingController();
  TextEditingController FullHeadingController = TextEditingController();
  FileUploader? thumbnail;
  FileUploader? pinDiagram;


  int selectedPointIndex = -1;

  TextEditingController AboutHeadingController = TextEditingController();
  TextEditingController TypeController = TextEditingController();

  List<FileUploader> ImageList = [];

  List<TableConvertor> tableList = [];
  TextEditingController col0Controller = TextEditingController();
  TextEditingController col1Controller = TextEditingController();
  int selectedTableIndex = -1;



  @override
  void initState() {
    super.initState();
    if(widget.data!=null)autoFill();
  }

  autoFill() {
    setState(() {
      ShortHeadingController.text=widget.data!.heading.short;
      FullHeadingController.text=widget.data!.heading.full;
      FullHeadingController.text=widget.data!.heading.full;
      thumbnail=widget.data!.thumbnail;
      pinDiagram=widget.data!.pinDiagram;
      pinConnectionsList=widget.data!.pinConnections;
      TypeController.text=widget.data!.type;
      ImageList=widget.data!.images;
      tableList=widget.data!.technicalParameters;
    });
  }



  void addTable() {
    setState(() {
      tableList.add(
          TableConvertor(col0: col0Controller.text, col1: col1Controller.text));
      col0Controller.clear();
      col1Controller.clear();
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


  List<TableConvertor> pinConnectionsList = [];
  TextEditingController col0pinConnectionsController = TextEditingController();
  TextEditingController col1pinConnectionsController = TextEditingController();
  int selectedPinConnectionsIndex = -1;

  void addpinConnections() {
    setState(() {
      pinConnectionsList.add(TableConvertor(
          col0: col0pinConnectionsController.text,
          col1: col1pinConnectionsController.text));
      col0pinConnectionsController.clear();
      col1pinConnectionsController.clear();
    });
  }


  void savepinConnections() {
    String newName = col0pinConnectionsController.text;
    String newScoreText = col1pinConnectionsController.text;

    if (newName.isNotEmpty &&
        newScoreText.isNotEmpty &&
        selectedPinConnectionsIndex != -1) {
      TableConvertor selectedPoint =
          pinConnectionsList[selectedPinConnectionsIndex];
      setState(() {
        selectedPoint.col0 = newName;
        selectedPoint.col1 = newScoreText;
        selectedPinConnectionsIndex = -1;
        col0pinConnectionsController.clear();
        col1pinConnectionsController.clear();
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
              Column(
                children: [
                  TextFieldContainer(
                      heading: "Short",
                      controller: ShortHeadingController,
                      hintText: 'short',
                      ),
                  TextFieldContainer(
                      heading: "Full",
                      controller: FullHeadingController,
                      hintText: 'Full',
                     )
                ],
              ),
              HeadingH2(heading:"Thumbnail"),
              Uploader(
                IVF: thumbnail != null
                      ? thumbnail!.fileUrl.isNotEmpty?[thumbnail!]:[]:[],
                getIVF: (value) {
                  setState(() {
                    thumbnail = value.first;
                  });
                },
                type: FileType.image,

                path: 'sensor',
              ),
              HeadingH2(heading: "Images"),
              Uploader(
                IVF: ImageList,
                getIVF: (value) {
                  setState(() {
                    ImageList = value;
                  });
                },
                type: FileType.image,
                allowMultiple: true,
                path: 'sensor',
              ),
              TextFieldContainer(
                  heading: "About",
                  controller: AboutHeadingController,
                  hintText: 'About',
                  ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    HeadingWithDivider(heading: "Technical Parameters"),
                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        tableList.length,
                        (index) => Container(
                          key: ValueKey(index),
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                          margin:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child:
                                                  Text(tableList[index].col0))),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Center(
                                              child:
                                                  Text(tableList[index].col1))),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPointIndex = index;
                                      col0Controller.text =
                                          tableList[index].col0;
                                      col1Controller.text =
                                          tableList[index].col1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Icon(Icons.edit),
                                  )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      tableList.removeAt(index);
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
                          tableList.insert(
                              newIndex, tableList.removeAt(oldIndex));
                        });
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextFieldContainer(
                              heading: "Col 0",
                              controller: col0Controller,
                              hintText: 'Col 0',
                             ),
                        ),
                        Flexible(
                          flex: 6,
                          child: TextFieldContainer(
                              controller: col1Controller,
                              hintText: 'Col 1',

                              heading: "Col 1",
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
                              selectedPointIndex != -1 ? Icons.save : Icons.add,
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
              HeadingH2(heading: "Pin Connects"),
              Uploader(
                IVF: pinDiagram != null
                    ? pinDiagram!.fileUrl.isNotEmpty?[pinDiagram!]:[]:[],
                getIVF: (value) {
                  setState(() {
                    pinDiagram = value.first;
                  });
                },
                type: FileType.image,

                path: 'sensor',
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    HeadingWithDivider(heading: "Pin Connects"),
                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        pinConnectionsList.length,
                            (index) => Container(
                          key: ValueKey(index),
                          padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                          margin:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child:
                                              Text(pinConnectionsList[index].col0))),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: Center(
                                              child:
                                              Text(pinConnectionsList[index].col1))),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPinConnectionsIndex = index;
                                      col0pinConnectionsController.text =
                                          pinConnectionsList[index].col0;
                                      col1pinConnectionsController.text =
                                          pinConnectionsList[index].col1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Icon(Icons.edit),
                                  )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      pinConnectionsList.removeAt(index);
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
                          pinConnectionsList.insert(
                              newIndex, pinConnectionsList.removeAt(oldIndex));
                        });
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextFieldContainer(
                              controller: col0pinConnectionsController,
                              hintText: 'Col 0',

                              heading: "Col 0",
                             ),
                        ),
                        Flexible(
                          flex: 6,
                          child: TextFieldContainer(
                              controller: col1pinConnectionsController,
                              hintText: 'Col 1',

                              heading: "Col 1",
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
                              selectedPinConnectionsIndex != -1 ? Icons.save : Icons.add,
                              size: 45,
                            ),
                          ),
                          onTap: () {
                            selectedPinConnectionsIndex != -1
                                ? savepinConnections()
                                : addpinConnections();
                            col0pinConnectionsController.clear();
                            col1pinConnectionsController.clear();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),



              SizedBox(
                height: 10,
              ),


              TextFieldContainer(
                  heading: "Type",
                  controller: TypeController,
                  hintText: 'Enter Type Here',

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
                          String id = getID();
                          if(widget.data==null){
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
                              descriptions: [],
                              technicalParameters: tableList,
                              pinConnections: pinConnectionsList,
                              type: TypeController.text,
                              pinDiagram: pinDiagram!=null?pinDiagram!:FileUploader(
                                  type: "",
                                  fileUrl: "",
                                  fileName: "",
                                  size: "",
                                  fileMessageId: 0,
                                  thumbnailUrl: "",
                                  thumbnailMessageId: 0),
                              thumbnail: thumbnail!=null?thumbnail!:FileUploader(
                                  type: "",
                                  fileUrl: "",
                                  fileName: "",
                                  size: "",
                                  fileMessageId: 0,
                                  thumbnailUrl: "",
                                  thumbnailMessageId: 0),
                            ).toJson());
                          }else{
                            await FirebaseFirestore.instance
                                .collection('sensors')
                                .doc(widget.data!.id)
                                .update(SensorsConverter(
                              id: widget.data!.id,
                              heading: HeadingConvertor(
                                full: FullHeadingController.text,
                                short: ShortHeadingController.text,
                              ),
                              images: ImageList,
                              about: AboutHeadingController.text,
                              descriptions: widget.data!.descriptions,
                              technicalParameters: tableList,
                              pinConnections: pinConnectionsList,
                              type: TypeController.text,
                              pinDiagram: pinDiagram!=null?pinDiagram!:FileUploader(
                                  type: "",
                                  fileUrl: "",
                                  fileName: "",
                                  size: "",
                                  fileMessageId: 0,
                                  thumbnailUrl: "",
                                  thumbnailMessageId: 0),
                              thumbnail: thumbnail!=null?thumbnail!:FileUploader(
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
