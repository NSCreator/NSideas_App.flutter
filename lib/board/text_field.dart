import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../functions.dart';
import '../project_files/projects_test.dart';
import '../test1.dart';
import 'converter.dart';

class arduinoBoardCreator extends StatefulWidget {
  arduinoBoardCreator({
    Key? key,
  }) : super(key: key);

  @override
  State<arduinoBoardCreator> createState() => _arduinoBoardCreatorState();
}

class _arduinoBoardCreatorState extends State<arduinoBoardCreator> {
  final shortController = TextEditingController();
  final fullController = TextEditingController();
  final AboutController = TextEditingController();
  final TypeController = TextEditingController();
  List<String> urls = [];
  List<String> circuitUrls = [];

  @override
  void initState() {
    super.initState();
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
                child: TextFormField(
                  controller: shortController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Short',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              TextFieldContainer(
                heading: "Full Heading",
                child: TextFormField(
                  controller: fullController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Full',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              TextFieldContainer(
                heading: "Description",
                child: TextFormField(
                  controller: AboutController,
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
                  "Main Photos",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              // Uploader(
              //   onChanged: (value) {
              //
              //     setState(() {
              //       urls=value;
              //     });
              //
              //   }, type: FileType.image,
              //   allowMultiple: true,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Text(
                  "Circuit Photos",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              // Uploader(
              //   onChanged: (value) {
              //
              //     setState(() {
              //       circuitUrls= value;
              //     });
              //
              //   }, type: FileType.image,
              //   allowMultiple: true,
              // ),
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
                        await FirebaseFirestore.instance

                            .collection("boards")
                            .doc(id)
                            .set(BoardsConverter(
                          id: id,
                          heading: HeadingConvertor(
                            full: fullController.text,
                            short: shortController.text,
                          ),
                          images: urls,
                          about: AboutController.text,
                          type: TypeController.text,
                          pinDiagrams: circuitUrls, descriptions: [],
                        ).toJson());
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
