// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nsideas/project_files/projects.dart';
import 'package:nsideas/project_files/projects_test.dart';
import 'package:nsideas/sensors/converter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nsideas/shopping/all_orders.dart';
import 'package:nsideas/shopping/cart.dart';
import 'package:nsideas/shopping/shopping_page.dart';
import 'dart:convert';
import 'apps/convertor.dart';
import 'auth/logIn_page.dart';
import 'board/converter.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'home_page/home_page.dart';
import 'message/messaging_page.dart';
import 'notifications/converter.dart';
import 'notifications/notification_page.dart';
import 'settings/settings.dart';
import 'shopping/Converter.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  handler(message);
}

Future<void> handler(RemoteMessage message) async {
  final notificationData = message.notification;
  if (notificationData != null) {
    await LocalNotifications.showSimpleNotification(
      title: notificationData.title ?? '',
      body: notificationData.body ?? '',
      payload: message.data.toString(),
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // if (initialNotification?.didNotificationLaunchApp == true) {
  //   // LocalNotifications.onClickNotification.stream.listen((event) {
  //   Future.delayed(Duration(seconds: 1), () {});
  // }
  // MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handler(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        handler(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handler(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NS Ideas',
      theme: ThemeData(
          useMaterial3: true,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          textTheme: GoogleFonts.muktaTextTheme(),
          splashFactory: NoSplash.splashFactory,
          scaffoldBackgroundColor: Colors.white),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<ProjectConverter> projects = [];
  List<BoardsConverter> boards = [];
  List<SensorsConverter> sensors = [];
  List<NotificationConverter> notification = [];
  List<ProductsConverter> products = [];
  List<HomePageImagesConvertor> HomePageImages = [];
  List<AppsConvertor> apps =[];
  late PageController _pageController;

  Future<dynamic> getDat(bool isReload) async {
    projects = await getProjects(isReload);
    apps = await getApps(isReload);
    notification = await getNotification(isReload);
    boards = await getBoards(isReload);
    sensors = await getSensors(isReload);
    products = await getProducts(isReload);
    HomePageImages = await getHomePageImages(isReload);

    setState(() {
      projects;
      boards;
      apps;
      sensors;
      notification;
      products;
      HomePageImages;
    });
  }

  @override
  void initState() {
    super.initState();
    getDat(true);
    listenToNotifications();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((payload) {
      print("Notification payload: $payload");
      var someData = jsonDecode(payload);
      if (someData['navigation'] == 'message') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => notifications()));
      } else if (someData['navigation'] == 'notification') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationPage(
                      notification: notification,
                    )));
      } else if (someData['navigation'] == 'all_orders') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => all_orders_page()));
      }
      showToastText("Notification payload: $payload");
    });
  }

  @override
  Widget build(BuildContext context) {
    return   HomePage(
      apps: apps,
      projects: projects,
      boards: boards,
      sensors: sensors,
      notification: notification,
      products: products,
      HomePageImages: HomePageImages,
    );
  }
}
