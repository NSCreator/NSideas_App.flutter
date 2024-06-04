import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/test.dart';

import '../sensors/sub_page.dart';
import '../uploader/telegram_uploader.dart';
import 'convertor.dart';

class AppCreator extends StatefulWidget {
  final AppsConverter? data;

  AppCreator({this.data});

  @override
  State<AppCreator> createState() => _AppCreatorState();
}

class _AppCreatorState extends State<AppCreator> {
  TextEditingController nameController = TextEditingController();
  TextEditingController versionController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController updateDateController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  TextEditingController appSupportedLanguagesController =
      TextEditingController();
  TextEditingController platformsController = TextEditingController();
  TextEditingController appSupportedDevicesController = TextEditingController();

  TextEditingController DevNameController = TextEditingController();
  TextEditingController DevWebSiteController = TextEditingController();
  TextEditingController DevEmailController = TextEditingController();
  FileUploader iconImage = FileUploader(
    type: "",
    size: "",
    fileUrl: "",
    fileMessageId: 0,
    thumbnailUrl: '',
    thumbnailMessageId: 0,
    fileName: '',
  );

  bool supportsAds = false;
  bool inAppPurchases = false;
  List<FileUploader> images = [];
  List<String> points = [];
  int selectedPointIndex =-1;
  List<String> appSupportedDevices = [];
  int selectedSupportedDevicesIndex =-1;
  List<AppDownloadLinks> appDownloadLinks = [];
  final TextEditingController platform_Controller = TextEditingController();
  final TextEditingController link_Controller = TextEditingController();

  int selectedAppDownloadLinks = -1;
  List<String> appSupportedLanguages = [];
  int selectedSupportedLanguagesIndex =-1;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) AutoFill();
  }

  AutoFill() {
    setState(() {
      nameController.text = widget.data!.name;
      versionController.text = widget.data!.version;
      sizeController.text = widget.data!.size;
      aboutController.text = widget.data!.about;
      updateDateController.text = widget.data!.updateDate;
      appDownloadLinks = widget.data!.appDownloadLinks;
      DevNameController.text = widget.data!.developer.name;
      DevWebSiteController.text = widget.data!.developer.website;
      DevEmailController.text = widget.data!.developer.email;
      points = widget.data!.points;
      appSupportedDevices = widget.data!.appSupportedDevices;
      appSupportedLanguages = widget.data!.appSupportedLanguages;
      inAppPurchases = widget.data!.inAppPurchases;
      supportsAds = widget.data!.supportsAds;
      if (widget.data!.icon.fileUrl.isNotEmpty) iconImage = widget.data!.icon;
      images = widget.data!.images;
    });
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
            TextFieldContainer(
              controller:nameController ,
              hintText: "Name",
              obscureText: false,

                heading: "Name",
                ),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextFieldContainer(
                      controller:versionController ,
                      hintText: "Version",
                      obscureText: false,
                      heading: "Version",
                      ),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "Size",
                      controller:sizeController ,
                      hintText: "Size",
                      obscureText: false,
                      ),
                ),
              ],
            ),
            TextFieldContainer(
                heading: "About App",
                controller:aboutController ,
                hintText: "About App",
                obscureText: false,),
            TextFieldContainer(
                heading: "Update Date",
                hintText: "Update Date",
                controller: updateDateController,
                obscureText: false,
                ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
              child: Text(
                "Icon",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Uploader(
              IVF: iconImage.fileUrl.isNotEmpty ? [iconImage] : [],
              type: FileType.image,
              path: "app",
              getIVF: (e) {
                setState(() {
                  iconImage = e.first;
                });
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "Points"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      points.length,
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
                                Expanded(child: Text(points[index])),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPointIndex = index;
                                        pointsController.text = points[index];
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
                                        points.removeAt(index);
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

                        points.insert(newIndex, points.removeAt(oldIndex));
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          controller: pointsController,
                          obscureText: false,
                          hintText: "Enter Tags Here",

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
                            selectedPointIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedPointIndex >= 0) {
                              points[selectedPointIndex] =
                                  pointsController.text;
                            } else {
                              points.add(pointsController.text);
                            }
                          });
                          selectedPointIndex = -1;
                          pointsController.clear();
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
                  HeadingWithDivider(heading: "Supported Languages"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      appSupportedLanguages.length,
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
                                Expanded(child: Text(appSupportedLanguages[index])),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedSupportedLanguagesIndex = index;
                                        appSupportedLanguagesController.text = appSupportedLanguages[index];
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
                                        appSupportedLanguages.removeAt(index);
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

                        appSupportedLanguages.insert(newIndex, appSupportedLanguages.removeAt(oldIndex));
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          hintText: "Enter Tags Here",
                          controller: appSupportedLanguagesController,


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
                            selectedSupportedLanguagesIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedSupportedLanguagesIndex >= 0) {
                              appSupportedLanguages[selectedSupportedLanguagesIndex] =
                                  appSupportedLanguagesController.text;
                            } else {
                              appSupportedLanguages.add(appSupportedLanguagesController.text);
                            }
                          });
                          selectedSupportedLanguagesIndex = -1;
                          appSupportedLanguagesController.clear();
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
                  HeadingWithDivider(heading: "Supported Devices"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
                    children: List.generate(
                      appSupportedDevices.length,
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
                                Expanded(child: Text(appSupportedDevices[index])),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedSupportedDevicesIndex = index;
                                        appSupportedDevicesController.text = appSupportedDevices[index];
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
                                        appSupportedDevices.removeAt(index);
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

                        appSupportedDevices.insert(newIndex, appSupportedDevices.removeAt(oldIndex));
                      });
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFieldContainer(
                          controller: appSupportedDevicesController,
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
                            selectedSupportedDevicesIndex >= 0 ? "Save" : "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedSupportedDevicesIndex >= 0) {
                              appSupportedDevices[selectedSupportedDevicesIndex] =
                                  appSupportedDevicesController.text;
                            } else {
                              appSupportedDevices.add(appSupportedDevicesController.text);
                            }
                          });
                          selectedSupportedDevicesIndex = -1;
                          appSupportedDevicesController.clear();
                        },
                      )
                    ],
                  ),

                ],
              ),
            ),


            HeadingH2(heading: "Developer"),
            TextFieldContainer(
                heading: "Name",
                controller: DevNameController,
                hintText: 'Name',

            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "website Link",
                      controller: DevWebSiteController,
                      hintText: 'website Link',
                      ),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "email Link",
                      controller: DevEmailController,
                      hintText: 'email Link',
                    ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
              child: Text(
                "Screen Shots",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Uploader(
              IVF: images,
              type: FileType.image,
              path: "app",
              allowMultiple: true,
              getIVF: (id) {
                images.addAll(id);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  HeadingWithDivider(heading: "App Download Links"),
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      appDownloadLinks.length,
                      (index) => Container(
                          key: ValueKey(index),
                          // Assign a unique key to each item
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text("data")),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedAppDownloadLinks = index;

                                          platform_Controller.text =
                                              appDownloadLinks[index].platform;
                                          link_Controller.text =
                                              appDownloadLinks[index].link;
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
                                          appDownloadLinks.removeAt(index);
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
                              ),
                            ],
                          )),
                    ),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }

                        appDownloadLinks.insert(
                            newIndex, appDownloadLinks.removeAt(oldIndex));
                      });
                    },
                  ),
                  Column(
                    children: [
                      TextFieldContainer(
                          heading: "Platform",
                          hintText: 'Platform',
                          controller: platform_Controller,
                         ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                                heading: "Link",
                                controller: link_Controller,
                                hintText: 'Link',
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
                                selectedAppDownloadLinks >= 0 ? "Save" : "Add",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedAppDownloadLinks >= 0) {
                                  appDownloadLinks[selectedAppDownloadLinks] =
                                      AppDownloadLinks(
                                          platform: platform_Controller.text,
                                          link: link_Controller.text);
                                } else
                                  appDownloadLinks.add(AppDownloadLinks(
                                      platform: platform_Controller.text,
                                      link: link_Controller.text));
                                selectedAppDownloadLinks = -1;
                              });

                              platform_Controller.clear();
                              link_Controller.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: SwitchListTile(
                    title: Text('Supports Ads'),
                    value: supportsAds,
                    onChanged: (bool value) {
                      setState(() {
                        supportsAds = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: SwitchListTile(
                    title: Text('In-App Purchases'),
                    value: inAppPurchases,
                    onChanged: (bool value) {
                      setState(() {
                        inAppPurchases = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () {
                        String id = getID();
                        FirebaseFirestore.instance
                            .collection("apps")
                            .doc(widget.data != null ? widget.data!.id : id)
                            .set(AppsConverter(
                                    name: nameController.text,
                                    version: versionController.text,
                                    size: sizeController.text,
                                    supportsAds: supportsAds,
                                    points: points,
                                    inAppPurchases: inAppPurchases,
                                    developer: Developer(
                                        name: DevNameController.text,
                                        website: DevWebSiteController.text,
                                        email: DevEmailController.text),
                                    appSupportedDevices: appSupportedDevices,
                                    appSupportedLanguages:
                                        appSupportedLanguages,
                                    about: aboutController.text,
                                    updateDate: updateDateController.text,
                                    images: images,
                                    icon: iconImage,
                                    id: widget.data != null
                                        ? widget.data!.id
                                        : id,
                                    appDownloadLinks: appDownloadLinks)
                                .toJson());
                        Navigator.pop(context);
                      },
                      child: Text("Save")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
