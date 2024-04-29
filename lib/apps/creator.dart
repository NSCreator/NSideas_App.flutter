import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/functions.dart';

import '../uploader/telegram_uploader.dart';
import 'convertor.dart';

class AppCreator extends StatefulWidget {
  final AppsConvertor? data;

  AppCreator({this.data});

  @override
  State<AppCreator> createState() => _AppCreatorState();
}

class _AppCreatorState extends State<AppCreator> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bundleIdController = TextEditingController();
  TextEditingController versionController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController releaseDateController = TextEditingController();
  TextEditingController updateDateController = TextEditingController();
  TextEditingController appStoreLinkController = TextEditingController();
  TextEditingController playStoreLinkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController languagesController = TextEditingController();
  TextEditingController platformsController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();
  TextEditingController DevNameController = TextEditingController();
  TextEditingController DevWebSiteController = TextEditingController();
  TextEditingController DevEmailController = TextEditingController();
  IVFUploader iconImage =
      IVFUploader(type: "",size: "", file_url: "", file_messageId: 0, thumbnail_url: '', thumbnail_messageId: 0, file_name: '',);

  bool supportsAds = false;
  bool inAppPurchases = false;
  List<IVFUploader> screenshots = [];
  List<String> description = [];
  List<String> categories = [];
  List<String> platforms = [];
  List<String> languages = [];

  @override
  void initState() {
    super.initState();
    if (widget.data!=null) AutoFill();
  }

  AutoFill() {
    setState(() {
      nameController.text = widget.data!.name;
      bundleIdController.text = widget.data!.bundleId;
      versionController.text = widget.data!.version;
      sizeController.text = widget.data!.size;
      releaseDateController.text = widget.data!.about;
      updateDateController.text = widget.data!.updateDate;
      appStoreLinkController.text = widget.data!.appStoreLink;
      playStoreLinkController.text = widget.data!.playStoreLink;
      DevNameController.text = widget.data!.developer.name;
      DevWebSiteController.text = widget.data!.developer.website;
      DevEmailController.text = widget.data!.developer.email;
      description = widget.data!.description;
      categories = widget.data!.supported;
      platforms = widget.data!.platforms;
      languages = widget.data!.languages;
      inAppPurchases = widget.data!.inAppPurchases;
      supportsAds = widget.data!.supportsAds;
      iconImage = widget.data!.icon;
      screenshots = widget.data!.screenshots;
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
                heading: "Name",
                child: TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black)),
                )),
            TextFieldContainer(
                heading: "Bundle Id",
                child: TextFormField(
                  controller: bundleIdController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Bundle Id',
                      hintStyle: TextStyle(color: Colors.black)),
                )),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextFieldContainer(
                      heading: "Version",
                      child: TextFormField(
                        controller: versionController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Version',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "Size",
                      child: TextFormField(
                        controller: sizeController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Size',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "Release Date",
                      child: TextFormField(
                        controller: releaseDateController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Release Date',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "updateDate",
                      child: TextFormField(
                        controller: updateDateController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'updateDate',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "playStore Link",
                      child: TextFormField(
                        controller: playStoreLinkController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'playStore Link',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "AppStore Link",
                      child: TextFormField(
                        controller: appStoreLinkController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'AppStore Link',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
              child: Text(
                "Icon",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Uploader(
              ivf: [iconImage],
              type: FileType.image,
              path: "app",
              getIVF: (e) {
                setState(() {
                  iconImage = e.first;
                });
              },
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
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
              children: List.generate(
                description.length,
                (index) => Container(
                  key: ValueKey(index),
                  // Assign a unique key to each item
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    description[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = description.removeAt(oldIndex);
                  description.insert(newIndex, item);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "description",
                      child: TextFormField(
                        controller: descriptionController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'description',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      description.add(descriptionController.text);
                      descriptionController.clear();
                    });
                  },
                  child: Text("ADD"),
                )
              ],
            ),
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
              children: List.generate(
                languages.length,
                (index) => Container(
                  key: ValueKey(index),
                  // Assign a unique key to each item
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    languages[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = languages.removeAt(oldIndex);
                  languages.insert(newIndex, item);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "languages",
                      child: TextFormField(
                        controller: languagesController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'languages',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      languages.add(languagesController.text);
                      languagesController.clear();
                    });
                  },
                  child: Text("ADD"),
                )
              ],
            ),
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
              children: List.generate(
                platforms.length,
                (index) => Container(
                  key: ValueKey(index),
                  // Assign a unique key to each item
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    platforms[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = platforms.removeAt(oldIndex);
                  platforms.insert(newIndex, item);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "platforms",
                      child: TextFormField(
                        controller: platformsController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'platforms',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      platforms.add(platformsController.text);
                      platformsController.clear();
                    });
                  },
                  child: Text("ADD"),
                )
              ],
            ),
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 1),
              children: List.generate(
                categories.length,
                (index) => Container(
                  key: ValueKey(index),
                  // Assign a unique key to each item
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = categories.removeAt(oldIndex);
                  categories.insert(newIndex, item);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "categories",
                      child: TextFormField(
                        controller: categoriesController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'categories',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      categories.add(categoriesController.text);
                      categoriesController.clear();
                    });
                  },
                  child: Text("ADD"),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
              child: Text(
                "Developer",
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextFieldContainer(
                heading: "Name",
                child: TextFormField(
                  controller: DevNameController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black)),
                )),
            Row(
              children: [
                Flexible(
                  child: TextFieldContainer(
                      heading: "website Link",
                      child: TextFormField(
                        controller: DevWebSiteController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'website Link',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
                ),
                Flexible(
                  child: TextFieldContainer(
                      heading: "email Link",
                      child: TextFormField(
                        controller: DevEmailController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'email Link',
                            hintStyle: TextStyle(color: Colors.black)),
                      )),
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
              ivf: screenshots,
              type: FileType.image,
              path: "app",
              allowMultiple: true,
              getIVF: (id) {
                screenshots.addAll(id);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,bottom: 100),
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
                            .doc(widget.data!=null?widget.data!.id : id)
                            .set(AppsConvertor(
                                    name: nameController.text,
                                    description: description,
                                    size: sizeController.text,
                                    bundleId: bundleIdController.text,
                                    version: versionController.text,
                                    supportsAds: supportsAds,
                                    inAppPurchases: inAppPurchases,
                                    developer: Developer(
                                        name: DevNameController.text,
                                        website: DevWebSiteController.text,
                                        email: DevEmailController.text),
                                    supported: categories,
                                    platforms: platforms,
                                    languages: languages,
                                    about: releaseDateController.text,
                                    updateDate: updateDateController.text,
                                    screenshots: screenshots,
                                    icon: iconImage,
                                    appStoreLink: appStoreLinkController.text,
                                    playStoreLink: playStoreLinkController.text,
                                    id: widget.data!=null?widget.data!.id : id)
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
