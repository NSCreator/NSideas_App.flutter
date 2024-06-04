// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsideas/apps/creator.dart';
import 'package:nsideas/auth/logIn_page.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/settings/testing.dart';
import 'package:nsideas/shopping/orders.dart';
import 'package:nsideas/textFeild.dart';

import '../apps/convertor.dart';
import '../board/creator.dart';
import '../functions.dart';

import 'dart:async';

import '../home_page/home_page.dart';
import '../message/messaging_page.dart';
import '../notifications/creator.dart';
import '../sensors/creator.dart';
import '../shopping/all_orders.dart';
import '../test.dart';

String version = "1.0.1";
String noImageUrl = "No Photo Url Available";
String longPressToViewImage = "Long Press To View Image";
final String token = '7145103395:AAExw7kwzFyB6lKcEDn4IxEl_7QyTomFhEE'; //NsIdeas
final String testingToken =
    '7152765208:AAFtlX5uwyoa4kL2Ie_jj3nxTVm_IOmiMxk'; //tester
final String telegramId = '1314922309';
final FirebaseAuth auth = FirebaseAuth.instance;
const TextStyle HeadingsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

FullUser() {
  return FirebaseAuth.instance.currentUser!.email! ?? "";
}

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    List<String> creatingHeadings = [
      "Board",
      "Project",
      "Product",
      "App",
      "Sensor",
      "Notification"
    ];
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingH1(heading: "Settings"),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => settings()));
                    },
                    child: isAnonymousUser()
                        ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white70,
                      ),
                    )
                        : Container(
                      height: 45,
                      width: 45,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: auth.currentUser?.photoURL != null
                              ? Colors.white10
                              : Colors.white24,
                        ),
                      ),
                      child: auth.currentUser?.photoURL != null
                          ? Image.network(
                        auth.currentUser?.photoURL ?? "",
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isAnonymousUser()
                                    ? "Guest"
                                    : auth.currentUser?.displayName ?? "No Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            if (!isAnonymousUser()) InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                            onChange: (a) {
                                              setState(() {});
                                            },
                                          )));
                                },
                                child: Icon(Icons.edit,color: Colors.white38,size: 20,))
                          ],
                        ),
                        if (!isAnonymousUser())
                          Text(
                            auth.currentUser?.email ?? "",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white10,borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [

                  if (!isAnonymousUser())Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Account",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const UpdatePasswordPage()));
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white12),

                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.password,
                                          size: 25,
                                          color: Colors.white70,
                                        ),
                                        Text(
                                          " Update Password",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    final FirebaseAuth _auth = FirebaseAuth.instance;
                                    User? user = _auth.currentUser;

                                    // Show confirmation dialog
                                    bool confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete Your Account'),
                                          content: Text(
                                              'Are you sure you want to delete your account?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(false),
                                              // Cancel
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(true),
                                              // Confirm
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      await user!.delete();
                                      await FirebaseAuth.instance.signOut();
                                      showToastText('Account deleted successfully');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Scaffold(body: LoginPage())));
                                    } else {
                                      showToastText('Account deletion cancelled');
                                    }
                                  } catch (e) {
                                    print('Failed to delete account: $e');
                                    showToastText("Error : $e");
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_remove_alt_1_outlined,
                                          size: 25,
                                          color: Colors.white70,
                                        ),
                                        Text(
                                          " Delete My Account",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.orange),
                                        ),

                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => orders_page())),
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list_alt,
                                  size: 25,
                                  color: Colors.white70,
                                ),
                                Text(
                                  " My Orders",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 25,
                                  color: Colors.white24,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            HeadingH2(heading: "More Settings"),
            if (!isAnonymousUser())
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Report",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white24,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        sendingMails("sujithnimmala03@gmail.com");
                      },
                    ),
                  ],
                ),
              ),
            if (isOwner())
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HeadingH2(heading: "Update App"),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref("Updated")
                                  .set(version + "," + getID().toString());
                              showToastText("Data Updated");
                            },
                            child: Text("Update"))
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => all_orders_page())),
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.list_alt,
                                size: 30,
                                color: Colors.white70,
                              ),
                              Text(
                                " All Orders",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 30,
                                color: Colors.white24,
                              ),
                            ],
                          )),
                    ),
                    HeadingH1(heading: "Create All"),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // number of items in each row
                          childAspectRatio: 16 / 4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      padding: EdgeInsets.all(8.0),
                      itemCount: creatingHeadings.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (creatingHeadings[index] == "Board") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BoardCreator()));
                            } else if (creatingHeadings[index] == "Project") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectCreator()));
                            } else if (creatingHeadings[index] == "Product") {
                            } else if (creatingHeadings[index] == "App") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppCreator()));
                            } else if (creatingHeadings[index] == "Sensor") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SensorsCreator()));
                            } else if (creatingHeadings[index] ==
                                "Notification") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationCreator()));
                            }
                          },
                          child: Container(
                            color: Colors.white10, // color of grid items
                            child: Center(
                              child: Text(
                                creatingHeadings[index],
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                "Developed and designed by Nimmala Sujith.",
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    "Contact: ",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    "sujithnimmala03@gmail.com",
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ));
                if (isAnonymousUser()) {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  User? user = _auth.currentUser;
                  await user!.delete();
                  await FirebaseAuth.instance.signOut();
                  showToastText('Account deleted successfully');
                } else {
                  await FirebaseAuth.instance.signOut();
                }
                Navigator.pop(context);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      isAnonymousUser() ? "LogOut as Guest" : "Log Out",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    ));
  }
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => followUsConvertor.fromJson(doc.data()))
        .toList());

class followUsConvertor {
  String id;
  final String name, link, photoUrl;

  followUsConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          photoUrl: json["photoUrl"]);
}

class EditProfilePage extends StatefulWidget {
  Function(bool) onChange;

  EditProfilePage({required this.onChange});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _nameController.text = _user?.displayName ?? "";
      });
    }
  }


  Future<void> _updateProfile() async {
    if (!mounted) return; // Check if widget is still mounted

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Circular loading indicator
        );
      },
    );

    try {

      await _user!.updateDisplayName(
          _nameController.text);

      if (!mounted)
        return;
      Navigator.of(context).pop(); // Dismiss the loading indicator

      widget.onChange(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      if (!mounted) return; // Check if mounted before showing SnackBar
      Navigator.of(context).pop(); // Dismiss the loading indicator

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            HeadingH1(heading: "Edit Profile"),
            TextFieldContainer(
              controller: _nameController,
              hintText: 'Name',

              heading: "Profile Name",
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _updateProfile();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
