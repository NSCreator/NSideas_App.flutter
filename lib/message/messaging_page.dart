// @immutable

// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../functions.dart';
import '../home_page/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NameAndDateConvertor {
  String name;
  String emailId;
  String photoUrl;
  late String lastUpdatedTime; // Remove the 'final' keyword here

  NameAndDateConvertor({
    required this.name,
    required this.emailId,
    required this.photoUrl,
    required this.lastUpdatedTime,
  });

  factory NameAndDateConvertor.fromMap(Map<String, dynamic> map) {
    return NameAndDateConvertor(
      name: map['name'],
      emailId: map['emailId'],
      photoUrl: map['photoUrl'],
      lastUpdatedTime: map['lastUpdatedTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'emailId': emailId,
      'photoUrl': photoUrl,
      'lastUpdatedTime': lastUpdatedTime,
    };
  }
}

picText(String id) {
  var user;
  user = FirebaseAuth.instance.currentUser!.email!.split("@");
  if (id.isNotEmpty) user = id.split("@");
  return user[0].substring(user[0].length - 3).toUpperCase();
}

class notifications extends StatefulWidget {
  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  final TextEditingController _filterController = TextEditingController();
  List<NameAndDateConvertor> _filteredNamesAndDates = [];

  final emailController = TextEditingController();
  Map<String, Color> colorMap = {};

  Color getColorForCombination(String combination) {
    if (!colorMap.containsKey(combination)) {
      colorMap[combination] =
          Color(0xFF000000 + (combination.hashCode & 0xFFFFFF));
    }
    return colorMap[combination]!;
  }

  bool isExp = false;
  late String image = "";
  late String email = "";

  Future<void> fetchAndProcessDocument(String filter) async {
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc('sujithnaidu03@gmail.com');

    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        List<dynamic> namesAndDatesList = data["namesAndDates"];
        List<NameAndDateConvertor> namesAndDates =
            namesAndDatesList.map((item) {
          return NameAndDateConvertor.fromMap(item as Map<String, dynamic>);
        }).toList();
        if (filter.isNotEmpty) {
          namesAndDates = namesAndDates
              .where((item) =>
                  item.name.toLowerCase().contains(filter.toLowerCase()) ||
                  item.emailId.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        }

        namesAndDates.sort((a, b) {
          DateTime aDate = DateTime.parse(
              a.lastUpdatedTime); // Assuming a.id is a date string
          DateTime bDate = DateTime.parse(
              b.lastUpdatedTime); // Assuming b.id is a date string
          return aDate.compareTo(bDate);
        });

        setState(() {
          _filteredNamesAndDates = namesAndDates.reversed.toList();
        });
      }
    }
  }

  void _filterData() {
    fetchAndProcessDocument(_filterController.text);
  }

  @override
  void initState() {
    super.initState();
    _filterController.addListener(_filterData);
    fetchAndProcessDocument("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                child: Text(
                  "Messages ( - Testing - )",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white54,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: _filterController,
                          maxLines: null,
                          scrollPhysics: BouncingScrollPhysics(),
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' search people here',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onChanged: (e){
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                    if (_filterController.text.isNotEmpty)
                      InkWell(
                          onTap: () {
                            _filterController.clear();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.orangeAccent,
                          )),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount: _filteredNamesAndDates.length,
                      itemBuilder: (BuildContext content, int index) {
                        final subData = _filteredNamesAndDates[index];
                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => notification(
                                          email: subData.emailId,
                                        )));
                            fetchAndProcessDocument("");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subData.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          subData.emailId,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
            ]),
      ),
      floatingActionButton: _filterController.text.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => notification(
                              email: _filterController.text,
                            )));
                fetchAndProcessDocument("");
              },
              child: Icon(Icons.send),
            )
          : null,
    );
  }
}

class notification extends StatefulWidget {
  String email;

  notification({required this.email});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  final TextEditingController bodyController = TextEditingController();

  String timeAgoSinceDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return '1 week ago';
      } else if (weeks < 4) {
        return '$weeks weeks ago';
      } else {
        return DateFormat('yyyy-MM-dd hh:mm a')
            .format(date); // Shows date and time in AM/PM format
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                  child: Text(
                    isOwner() ? widget.email : "Messages",
                    style: TextStyle(
                        fontSize: isOwner() ? 20 : 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<NotificationsConvertor>>(
                      stream: isOwner()
                          ? readOwnerNotifications(widget.email)
                          : readNotifications(),
                      builder: (context, snapshot) {
                        final Notifications = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 0.3,
                              color: Colors.cyan,
                            ));
                          default:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text(
                                      'Error with TextBooks Data or\n Check Internet Connection'));
                            } else {
                              return ListView.separated(
                                  padding: EdgeInsets.only(bottom: 80),
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: Notifications!.length,
                                  itemBuilder: (context, int index) {
                                    final Notification = Notifications[index];
                                    return PopupMenuButton(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: Notification.isOwner
                                                  ? 40
                                                  : 10,
                                              top: 2,
                                              right: !Notification.isOwner
                                                  ? 40
                                                  : 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Notification.message,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    timeAgoSinceDate(
                                                        Notification.id),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      // Callback that sets the selected popup menu item.
                                      onSelected: (item) {
                                        if (item == "delete") {
                                          if (isOwner())
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FullUser())
                                                .collection("messages")
                                                .doc("chatting")
                                                .collection(widget.email)
                                                .doc(Notification.id)
                                                .delete();
                                          else
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FullUser())
                                                .collection("chattingMessages")
                                                .doc(Notification.id)
                                                .delete();
                                          showToastText(
                                              "Your Message has been Deleted");
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          value: "delete",
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 2,
                                      ));
                            }
                        }
                      }),
                ),
              ]),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          // border: Border.all(color: Colors.  black26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: bodyController,
                                  maxLines: null,
                                  scrollPhysics: BouncingScrollPhysics(),
                                  textInputAction: TextInputAction.newline,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: ' Message ',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showToastText("Coming Soon");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 15.0, left: 5),
                                child: Icon(
                                  Icons.link,
                                  color: Colors.white70,
                                  size: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: Colors.orangeAccent,
                        size: 35,
                      ),
                      onTap: () async {
                        String id = DateTime.now().toString();
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc("sujithnaidu03@gmail.com")
                            .collection("messages")
                            .doc("chatting")
                            .collection(isOwner() ? widget.email : FullUser())
                            .doc(id)
                            .set(NotificationsConvertor(
                                    id: id,
                                    message: bodyController.text,
                                    fileUrl: '',
                                    isOwner: isOwner(),
                                    fileNo: 0,
                                    fileType: '')
                                .toJson());

                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(isOwner() ? widget.email : FullUser())
                            .collection("chattingMessages")
                            .doc(id)
                            .set(NotificationsConvertor(
                                    id: id,
                                    message: bodyController.text,
                                    fileUrl: '',
                                    isOwner: !isOwner(),
                                    fileNo: 0,
                                    fileType: '')
                                .toJson());

                        final documentRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc('sujithnaidu03@gmail.com');

                        final docSnapshot = await documentRef.get();

                        if (docSnapshot.exists) {
                          final data = docSnapshot.data();
                          if (data != null) {
                            print("Document data: $data");

                            if (data.containsKey("namesAndDates")) {
                              var namesAndDatesField = data["namesAndDates"];

                              if (namesAndDatesField is List) {
                                List<dynamic> namesAndDatesList =
                                    namesAndDatesField;
                                List<NameAndDateConvertor> namesAndDates =
                                    namesAndDatesList.map((item) {
                                  return NameAndDateConvertor.fromMap(
                                      item as Map<String, dynamic>);
                                }).toList();

                                final currentUser =
                                    isOwner() ? widget.email : FullUser();

                                final userExists = namesAndDates
                                    .any((e) => e.emailId == currentUser);
                                if (userExists) {
                                  namesAndDates
                                      .where((e) => e.emailId == currentUser)
                                      .forEach((e) => e.lastUpdatedTime = id);
                                } else {
                                  namesAndDates.add(
                                    NameAndDateConvertor(
                                      name: auth.currentUser?.displayName ?? "",
                                      emailId: currentUser,
                                      photoUrl: "",
                                      lastUpdatedTime: id,
                                    ),
                                  );
                                }

                                namesAndDates.sort((a, b) => a.lastUpdatedTime
                                    .compareTo(b.lastUpdatedTime));

                                List<Map<String, dynamic>>
                                    sortedNamesAndDatesList = namesAndDates
                                        .map((item) => item.toMap())
                                        .toList();

                                await documentRef.set({
                                  'namesAndDates': sortedNamesAndDatesList,
                                });
                              } else {
                                // Log if namesAndDates is not a list
                                print("Error: 'namesAndDates' is not a List");
                              }
                            } else {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('sujithnaidu03@gmail.com').set({
                                "namesAndDates":[]
                              });
                            }
                          } else {
                            // Log if document data is null
                            print("Error: Document data is null");
                          }
                        } else {
                          // Log if document does not exist
                          print("Error: Document does not exist");
                        }

                        // if (isOwner() && email.isNotEmpty) {
                        //   pushNotificationsSpecificPerson(
                        //       "sujithnimmala03@gmail.com-$email",
                        //       bodyController.text,
                        //       image,
                        //       {"navigation": "messages"});
                        //   setState(() {
                        //     email = "";
                        //   });
                        // }
                        // else {
                        //   pushNotificationsSpecificPerson(
                        //       "${FullUser()}-sujithnimmala03@gmail.com",
                        //       bodyController.text,
                        //       image,
                        //       {"navigation": "messages"});
                        // }

                        bodyController.clear();
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    ));
  }
}

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER =
      "AAAAdU8wEPc:APA91bHyxWU9PymMERIQn4uRwwOL268H1yRpBl-i9K-6nMk05Pbca0H1posEf75yXowVDhudECSpWL9wRDAjjwLnVFda2-TfQQCvc4a4Z_ab7NLqghzKUFGMeIt2uKrYrJSIIhzGiqHZ";
  static final String SENDER_ID = '503839723767';
}

Future<void> sendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

class Utils {
  static showSnackBar(String? text) {
    if (text == null) return;
    SnackBar(content: Text(text), backgroundColor: Colors.orange);
  }
}

//
// Future<bool> pushNotificationsSpecificDevice({
//   required String token,
//   required String title,
//   required String body,
// }) async {
//   String dataNotifications = '{ "to" : "$token",'
//       ' "notification" : {'
//       ' "title":"$title",'
//       '"body":"$body"'
//       ' }'
//       ' }';
//
//   await http.post(
//     Uri.parse(Constants.BASE_URL),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key= ${Constants.KEY_SERVER}',
//     },
//     body: dataNotifications,
//   );
//   return true;
// }
Future<bool> pushNotificationsSpecificDevice({
  required String token,
  required String title,
  required String body,
  required Map<String, dynamic> payload,
}) async {
  // Constructing the notification payload with data
  Map<String, dynamic> notification = {
    'title': title,
    'body': body,
  };

  Map<String, dynamic> dataNotifications = {
    'to': token,
    'notification': notification,
    'data': payload, // Adding the payload data here
  };

  // Sending the notification
  http.Response response = await http.post(
    Uri.parse(Constants.BASE_URL),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=${Constants.KEY_SERVER}',
    },
    body: jsonEncode(dataNotifications),
  );

  // Returning true if the notification was successfully sent
  return response.statusCode == 200;
}

messageToOwner(
    {required String message,
    String head = "",
    required Map<String, dynamic> payload}) async {
  FirebaseFirestore.instance
      .collection("users")
      .doc("sujithnimmala03@gmail.com")
      .collection("messages")
      .doc(getID())
      .set({
    "id": getID(),
    "fromTo": "~sujithnimmala03@gmail.com",
    "data": message,
    "image": ""
  });
  FirebaseFirestore.instance
      .collection("tokens")
      .doc("sujithnimmala03@gmail.com")
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        String value = data['token'];
        pushNotificationsSpecificDevice(
          title: head,
          body: message,
          token: value,
          payload: payload,
        );
      }
    } else {
      print("Document does not exist.");
    }
  }).catchError((error) {
    print("An error occurred while retrieving data: $error");
  });
}

Future<void> pushNotificationsSpecificPerson(
  String user,
  String message,
  String url,
  Map<String, dynamic> payload,
) async {
  FirebaseFirestore.instance
      .collection("tokens")
      .doc(user.split("-").last)
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        String value = data['token'];
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.split("-").last)
            .collection("messages")
            .doc(getID())
            .set(
                {"id": getID(), "fromTo": user, "data": message, "image": url});
        FirebaseFirestore.instance
            .collection("users")
            .doc(FullUser())
            .collection("messages")
            .doc(getID())
            .set(
                {"id": getID(), "fromTo": user, "data": message, "image": url});

        pushNotificationsSpecificDevice(
            title: FullUser(), body: message, token: value, payload: payload);
      }
    } else {
      print("Document does not exist.");
    }
  }).catchError((error) {
    print("An error occurred while retrieving data: $error");
  });
}

void SendMessage(
    String title, String message, Map<String, dynamic> payload) async {
  final CollectionReference collectionRef = FirebaseFirestore.instance
      .collection('tokens'); // Replace with your collection name

  try {
    final QuerySnapshot querySnapshot = await collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        showToastText(data["id"]);
        await pushNotificationsSpecificDevice(
            title: title,
            body: message,
            token: data["token"],
            payload: payload);
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Stream<List<NotificationsConvertor>> readOwnerNotifications(String email) {
  return FirebaseFirestore.instance
      .collection("users")
      .doc("sujithnaidu03@gmail.com")
      .collection("messages")
      .doc("chatting")
      .collection(email)
      .snapshots()
      .map((snapshot) {
    final List<NotificationsConvertor> data = snapshot.docs
        .map((doc) => NotificationsConvertor.fromJson(doc.data()))
        .toList();

    // Sorting the list by date
    data.sort((a, b) {
      DateTime aDate = DateTime.parse(a.id); // Assuming a.id is a date string
      DateTime bDate = DateTime.parse(b.id); // Assuming b.id is a date string
      return aDate.compareTo(bDate);
    });

    // Reversing the list and converting it back to List
    return data.reversed.toList();
  });
}

Stream<List<NotificationsConvertor>> readNotifications() {
  final String userId = FullUser(); // Ensure this returns a valid user ID

  return FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("chattingMessages")
      .snapshots()
      .map((snapshot) {
    final List<NotificationsConvertor> notifications = snapshot.docs
        .map((doc) => NotificationsConvertor.fromJson(doc.data()))
        .toList();

    // Optionally sort the notifications by date or another field if needed
    notifications.sort((a, b) {
      DateTime aDate = DateTime.parse(a.id); // Assuming a.id is a date string
      DateTime bDate = DateTime.parse(b.id); // Assuming b.id is a date string
      return aDate.compareTo(bDate);
    });

    return notifications.reversed.toList();
  });
}

class NotificationsConvertor {
  String id;
  int fileNo;
  String fileType, fileUrl;
  final String message;
  bool isOwner;

  NotificationsConvertor({
    this.id = "",
    required this.message,
    required this.fileUrl,
    required this.isOwner,
    required this.fileNo,
    required this.fileType,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "fileUrl": fileUrl,
        "isOwner": isOwner,
        "fileNo": fileNo,
        "fileType": fileType,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(
        id: json['id'],
        fileType: json["fileType"],
        fileNo: json["fileNo"],
        isOwner: json["isOwner"],
        message: json["message"],
        fileUrl: json["fileUrl"],
      );
}

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  // to show periodic notification at regular interval
  static Future showPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 2', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1, title, body, RepeatInterval.everyMinute, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload);
  }

  // to schedule a local notification
  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'channel 3', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
