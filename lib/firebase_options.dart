// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBscgTWKBCQF8Udh5wFyDDqHcB-PQ2873M',
    appId: '1:503839723767:web:708821849baccb2e8a43f2',
    messagingSenderId: '503839723767',
    projectId: 'ns-ideas-app',
    authDomain: 'ns-ideas-app.firebaseapp.com',
    storageBucket: 'ns-ideas-app.appspot.com',
    measurementId: 'G-7XVPR9RFXH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEZH-6FhsKTWjPb59jkCAPfrbKBerUfTk',
    appId: '1:503839723767:android:f869ec1115bcf60f8a43f2',
    messagingSenderId: '503839723767',
    projectId: 'ns-ideas-app',
    storageBucket: 'ns-ideas-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2XYfehfYdfd8hio7Qpq3XGPkYQls_n5g',
    appId: '1:503839723767:ios:9b0b652edc81895e8a43f2',
    messagingSenderId: '503839723767',
    projectId: 'ns-ideas-app',
    storageBucket: 'ns-ideas-app.appspot.com',
    iosClientId: '503839723767-8oc7kt8unv98t5g3drsi881mvue6gp68.apps.googleusercontent.com',
    iosBundleId: 'com.nimmalasujith.nsideas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2XYfehfYdfd8hio7Qpq3XGPkYQls_n5g',
    appId: '1:503839723767:ios:03abe54ace5d49df8a43f2',
    messagingSenderId: '503839723767',
    projectId: 'ns-ideas-app',
    storageBucket: 'ns-ideas-app.appspot.com',
    iosClientId: '503839723767-9mahj5kb7dekan6o37ikc9ihn6hufjp7.apps.googleusercontent.com',
    iosBundleId: 'com.nimmalasujith.nsideas.RunnerTests',
  );
}
