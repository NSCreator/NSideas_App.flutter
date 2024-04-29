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
import 'package:nsideas/settings/settings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../functions.dart';
import '../home_page/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  final emailController = TextEditingController();
  Map<String, Color> colorMap = {};

  Color getColorForCombination(String combination) {
    if (!colorMap.containsKey(combination)) {
      colorMap[combination] =
          Color(0xFF000000 + (combination.hashCode & 0xFFFFFF));
    }
    return colorMap[combination]!;
  }

  final TextEditingController bodyController = TextEditingController();

  bool isExp = false;
  late String image = "";
  late String email = "";


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
                        "Messages",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<NotificationsConvertor>>(
                          stream: readNotifications(),
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

                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (!(Notification.fromTo
                                                .split("-")
                                                .first ==
                                                FullUser()))
                                              Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(17),
                                                    color: getColorForCombination(
                                                        picText(
                                                            Notification.fromTo
                                                                .split(
                                                                "~")[0])),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        picText(
                                                            Notification.fromTo
                                                                .split("~")[0]),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      )),
                                                ),
                                              ),
                                            if ((Notification.fromTo
                                                .split("-")
                                                .first ==
                                                FullUser()))
                                              PopupMenuButton(
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                                // Callback that sets the selected popup menu item.
                                                onSelected: (item) {
                                                  if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(FullUser())
                                                        .collection("messages")
                                                        .doc(Notification.id)
                                                        .delete();
                                                    showToastText(
                                                        "Your Message has been Deleted");
                                                  } else if (item == "reply") {
                                                    setState(() {
                                                      email =
                                                          Notification.fromTo
                                                              .split("-")
                                                              .first;
                                                    });
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text('Delete'),
                                                  ),
                                                  if (isOwner())
                                                    const PopupMenuItem(
                                                      value: "reply",
                                                      child: Text('Reply'),
                                                    ),
                                                ],
                                              ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    15,
                                                  ),
                                                  color: Notification.fromTo
                                                      .split("~")[0] !=
                                                      FullUser()
                                                      ? Colors.white
                                                      : Colors.blue
                                                      .withOpacity(0.3),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "   ~ ${Notification
                                                                      .fromTo
                                                                      .split(
                                                                      "@")[0]}",
                                                                  style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    // color: getColorForCombination( picText(Notification.fromTo.split("~")[0])),
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      8, 1, 10,
                                                                      1),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        calculateTimeDifference(
                                                                            Notification
                                                                                .id),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            10.0,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500
                                                                          //   fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                left: 10,
                                                                right: 5,
                                                                top: 3,
                                                                bottom: 8,
                                                              ),
                                                              child: StyledTextWidget(
                                                                fontSize: 13,
                                                                text: Notification
                                                                    .data,
                                                              ),
                                                            ),
                                                            if (Notification
                                                                .image
                                                                .isNotEmpty)
                                                              Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15),
                                                                  child:
                                                                  ImageShowAndDownload(
                                                                    image: Notification
                                                                        .image,
                                                                    isZoom: true,
                                                                    id: '',
                                                                  ),
                                                                ),
                                                              )
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (!(Notification.fromTo
                                                .split("-")
                                                .first ==
                                                FullUser()))
                                              PopupMenuButton(
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                                // Callback that sets the selected popup menu item.
                                                onSelected: (item) {
                                                  if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(FullUser())
                                                        .collection("messages")
                                                        .doc(Notification.id)
                                                        .delete();
                                                    showToastText(
                                                        "Your Message has been Deleted");
                                                  } else if (item == "reply") {
                                                    setState(() {
                                                      email =
                                                          Notification.fromTo
                                                              .split("-")
                                                              .first;
                                                    });
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text('Delete'),
                                                  ),
                                                  if (isOwner())
                                                    const PopupMenuItem(
                                                      value: "reply",
                                                      child: Text('Reply'),
                                                    ),
                                                ],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Text(
                          email,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 7,
                            child: Padding(
                              padding:
                              EdgeInsets.all(5),
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
                                          textInputAction: TextInputAction
                                              .newline,
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
                                        padding: const EdgeInsets.only(
                                            right: 15.0, left: 5),
                                        child: Icon(
                                          Icons.link, color: Colors.white70,
                                          size: 35,),
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
                                color: Colors.green,
                                size: 35,
                              ),
                              onTap: () {
                                if (isOwner() && email.isNotEmpty) {
                                  pushNotificationsSpecificPerson(
                                      "sujithnimmala03@gmail.com-$email",
                                      bodyController.text,
                                      image,
                                      {"navigation": "messages"});
                                  setState(() {
                                    email = "";
                                  });
                                } else {
                                  pushNotificationsSpecificPerson(
                                      "${FullUser()}-sujithnimmala03@gmail.com",
                                      bodyController.text,
                                      image,
                                      {"navigation": "messages"});
                                }

                                bodyController.clear();
                              },
                            ),
                          )
                        ],
                      ),
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

messageToOwner({required String message, String head = "", required Map<String,
    dynamic> payload}) async {
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

Future<void> pushNotificationsSpecificPerson(String user,
    String message,
    String url,
    Map<String, dynamic> payload,) async {
  FirebaseFirestore.instance
      .collection("tokens")
      .doc(user
      .split("-")
      .last)
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        String value = data['token'];
        FirebaseFirestore.instance
            .collection("users")
            .doc(user
            .split("-")
            .last)
            .collection("messages")
            .doc(getID())
            .set({
          "id": getID(),
          "fromTo": user,
          "data": message,
          "image": url
        });
        FirebaseFirestore.instance
            .collection("users")
            .doc(FullUser())
            .collection("messages")
            .doc(getID())
            .set({
          "id": getID(),
          "fromTo": user,
          "data": message,
          "image": url
        });

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

void SendMessage(String title, String message,
    Map<String, dynamic> payload) async {
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

Stream<List<NotificationsConvertor>> readNotifications() =>
    FirebaseFirestore.instance
        .collection("users")
        .doc(FullUser())
        .collection("messages")
        .orderBy("id", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => NotificationsConvertor.fromJson(doc.data()))
            .toList());

class NotificationsConvertor {
  String id;
  final String fromTo, image, data;

  NotificationsConvertor({
    this.id = "",
    required this.fromTo,
    required this.image,
    required this.data,
  });

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "fromTo": fromTo,
        "image": image,
        "data": data,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(
        id: json['id'],
        fromTo: json["fromTo"],
        image: json["image"],
        data: json["data"],
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
