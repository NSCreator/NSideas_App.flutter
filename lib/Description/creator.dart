import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nsideas/Description/Converter.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/sensors/sub_page.dart';
import 'package:nsideas/textFeild.dart';
import 'package:nsideas/uploader/telegram_uploader.dart';

class DescriptionCreator extends StatefulWidget {
  final String id;
  final String mode;
  final int index;

  DescriptionConvertor? data;
  List<DescriptionConvertor>? descriptions;

  DescriptionCreator({
    this.data,
    this.descriptions,
    this.index = -1,
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

  List<FileUploader> ImageList = [];

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  autoFill() {
    if (widget.data != null) {
      HeadingController.text = widget.data!.heading;
      pointsList = widget.data!.points;
      ImageList = widget.data!.ivf;
      codeList = widget.data!.code;
      tableList = widget.data!.table;
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

  List<CodeFilesConvertor> codeList = [];
  final TextEditingController _CodeHeadingController = TextEditingController();
  final TextEditingController _CodeController = TextEditingController();
  final TextEditingController _CodeLangController = TextEditingController();
  FileUploader? Code_IVF;
  int selectedCodeIndex = -1;

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
              HeadingH1(heading: "Description Creator"),
              TextFieldContainer(
                  heading: "Heading",
                  controller: HeadingController, hintText: 'Heading', obscureText: false,
                  ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    HeadingWithDivider(heading: "Points"),
                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                      children: List.generate(
                        pointsList.length,
                            (index) => Container(
                          key: ValueKey(index),
                          // Assign a unique key to each item
                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(pointsList[index],style: TextStyle(color: Colors.white),)),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPointIndex = index;
                                      _pointsController.text =
                                      pointsList[index];
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
                                      pointsList.removeAt(index);
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

                          pointsList.insert(
                              newIndex, pointsList.removeAt(oldIndex));
                        });
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFieldContainer(
                     controller:  _pointsController, hintText: 'Enter Points Here', obscureText: false,

                          ),
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              selectedPointIndex >= 0 ? "Save" : "Add",
                              style: TextStyle(fontSize: 20,color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (selectedPointIndex >= 0) {
                                pointsList[selectedPointIndex] =
                                    _pointsController.text;
                              } else {
                                pointsList.add(_pointsController.text);
                              }
                            });
                            selectedPointIndex = -1;
                            _pointsController.clear();
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    HeadingWithDivider(heading: "Table"),
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
                              controller:  col0Controller, hintText: 'Col 0', obscureText: false,
                              heading: "Col 0",

                              ),
                        ),
                        Flexible(
                          flex: 6,
                          child: TextFieldContainer(
                              heading: "Col 1",
                              controller:  col1Controller, hintText: 'Col 0', obscureText: false,

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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    HeadingWithDivider(heading: "Files"),
                    Uploader(
                      type: FileType.any,
                      path: "projects/description",
                      allowMultiple: true,
                      getIVF: (data) {
                        setState(() {
                          ImageList = data;
                        });
                      },
                      IVF: ImageList,
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
                    HeadingWithDivider(heading: "Code"),
                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          codeList.length,
                              (index) => Container(
                              key: ValueKey(index),
                              margin: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Text(codeList[index].code,maxLines: 2,style: TextStyle(color: Colors.white),),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 3),
                                          decoration: BoxDecoration(
                                              color:
                                              Colors.blue.withOpacity(0.08),
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          codeList[index]
                                                              .heading,style: TextStyle(color: Colors.white))),),
                                              Container(
                                                height: 15,
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          codeList[index]
                                                              .lang,style: TextStyle(color: Colors.white)))),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedCodeIndex = index;

                                              _CodeHeadingController.text =
                                                  codeList[index].heading;

                                              _CodeLangController.text =
                                                  codeList[index].lang;
                                              ;

                                              _CodeController.text =
                                                  codeList[index].code;
                                              ;
                                            });
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black54,
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              deleteFileFromTelegramBot(
                                                  codeList[index]
                                                      .IVF
                                                      .fileMessageId);
                                              deleteFileFromTelegramBot(
                                                  codeList[index]
                                                      .IVF
                                                      .thumbnailMessageId);
                                              codeList.removeAt(index);
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ))),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }

                          codeList.insert(
                              newIndex, codeList.removeAt(oldIndex));
                        });
                      },
                    ),
                    Column(
                      children: [
                        TextFieldContainer(
                            controller:  _CodeController, hintText: 'Col 0', obscureText: false,
                            heading: "Code",
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldContainer(
                                  controller:  _CodeHeadingController, hintText: 'Heading', obscureText: false,

                                  heading: "Heading",
                                  ),
                            ),
                            Expanded(
                              child: TextFieldContainer(
                                  controller:  _CodeLangController, hintText: 'Id', obscureText: false,

                                  heading: "Lang",
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
                                      Code_IVF = IVFData.first;
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
                                  selectedCodeIndex >= 0 ? "Save" : "Add",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (selectedCodeIndex >= 0) {
                                    codeList[selectedCodeIndex] =
                                        CodeFilesConvertor(
                                            IVF: Code_IVF != null
                                                ? Code_IVF!
                                                : FileUploader(
                                                type: "",
                                                fileUrl: "",
                                                fileName: "",
                                                size: "",
                                                fileMessageId: 0,
                                                thumbnailUrl: "",
                                                thumbnailMessageId: 0),
                                            code: _CodeController.text,
                                            heading:
                                            _CodeHeadingController.text.trim(),
                                            lang: _CodeLangController.text.trim().toLowerCase());
                                  } else
                                    codeList.add(CodeFilesConvertor(
                                      heading: _CodeHeadingController.text.trim(),
                                      IVF: Code_IVF != null
                                          ? Code_IVF!
                                          : FileUploader(
                                          type: "",
                                          fileUrl: "",
                                          fileName: "",
                                          size: "",
                                          fileMessageId: 0,
                                          thumbnailUrl: "",
                                          thumbnailMessageId: 0),
                                      code: _CodeController.text,
                                      lang: _CodeLangController.text.trim().toLowerCase(),
                                    ));
                                  selectedCodeIndex = -1;
                                  Code_IVF = null;
                                });

                                _CodeController.clear();
                                _CodeHeadingController.clear();
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
                          if(widget.data != null && widget.descriptions != null){
                            widget.descriptions![widget.index] =
                                DescriptionConvertor(
                                  heading: HeadingController.text,
                                  points: pointsList,
                                  ivf: ImageList,
                                  code: codeList,
                                  table: tableList,
                                );

                            await FirebaseFirestore.instance
                                .collection(widget.mode)
                                .doc(widget.id)
                                .update({
                              'descriptions': widget.descriptions!.map((unit) => unit.toJson()).toList(),
                            });
                          }else{
                            await FirebaseFirestore.instance
                                .collection(widget.mode)
                                .doc(widget.id)
                                .update({
                              'descriptions': FieldValue.arrayUnion([
                                DescriptionConvertor(
                                  heading: HeadingController.text,
                                  points: pointsList,
                                  ivf: ImageList,
                                  code: codeList,
                                  table: tableList,
                                ).toJson(),
                              ]),
                            });
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
