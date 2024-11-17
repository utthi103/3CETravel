// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCqGmLf1G_zNfXgb42VWfv9s5mbRmX2Q8k',
    appId: '1:551230337362:web:85b7cd05362d8b1f84ca8b',
    messagingSenderId: '551230337362',
    projectId: 'cetravel-3bd3c',
    authDomain: 'cetravel-3bd3c.firebaseapp.com',
    databaseURL: 'https://cetravel-3bd3c-default-rtdb.firebaseio.com',
    storageBucket: 'cetravel-3bd3c.firebasestorage.app',
    measurementId: 'G-E78WB9DHVD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9t09dopE5237YfB7N1dIvPD66EL1FeHg',
    appId: '1:551230337362:android:76327d8a7987155284ca8b',
    messagingSenderId: '551230337362',
    projectId: 'cetravel-3bd3c',
    databaseURL: 'https://cetravel-3bd3c-default-rtdb.firebaseio.com',
    storageBucket: 'cetravel-3bd3c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxYI7nyl5fMowG9oEnomx5Age4UsgVy4w',
    appId: '1:551230337362:ios:0cc1a6a5c3f695b384ca8b',
    messagingSenderId: '551230337362',
    projectId: 'cetravel-3bd3c',
    databaseURL: 'https://cetravel-3bd3c-default-rtdb.firebaseio.com',
    storageBucket: 'cetravel-3bd3c.firebasestorage.app',
    iosBundleId: 'com.example.travelwith3ce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxYI7nyl5fMowG9oEnomx5Age4UsgVy4w',
    appId: '1:551230337362:ios:0cc1a6a5c3f695b384ca8b',
    messagingSenderId: '551230337362',
    projectId: 'cetravel-3bd3c',
    databaseURL: 'https://cetravel-3bd3c-default-rtdb.firebaseio.com',
    storageBucket: 'cetravel-3bd3c.firebasestorage.app',
    iosBundleId: 'com.example.travelwith3ce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCqGmLf1G_zNfXgb42VWfv9s5mbRmX2Q8k',
    appId: '1:551230337362:web:7af01c5d795eaa0084ca8b',
    messagingSenderId: '551230337362',
    projectId: 'cetravel-3bd3c',
    authDomain: 'cetravel-3bd3c.firebaseapp.com',
    databaseURL: 'https://cetravel-3bd3c-default-rtdb.firebaseio.com',
    storageBucket: 'cetravel-3bd3c.firebasestorage.app',
    measurementId: 'G-1RTFDTKTZY',
  );

}