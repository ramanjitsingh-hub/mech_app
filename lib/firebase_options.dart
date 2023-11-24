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
    apiKey: 'AIzaSyBBpy8PAKeb4o_-FLRPC1g1nSk7X6VL9NA',
    appId: '1:698023764311:web:e2829e3b9e6e97bfc85e12',
    messagingSenderId: '698023764311',
    projectId: 'mechanic-9eef3',
    authDomain: 'mechanic-9eef3.firebaseapp.com',
    storageBucket: 'mechanic-9eef3.appspot.com',
    measurementId: 'G-LM7VSRZJCT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKoQGXIZFcB1FjG2DMev2Z-ZL_SzKve9o',
    appId: '1:698023764311:android:eefd7a55f20c34c3c85e12',
    messagingSenderId: '698023764311',
    projectId: 'mechanic-9eef3',
    storageBucket: 'mechanic-9eef3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPDnX5dIVAZfZ121bGjwt7zyOVA_As8Gw',
    appId: '1:698023764311:ios:c66dceda01afff01c85e12',
    messagingSenderId: '698023764311',
    projectId: 'mechanic-9eef3',
    storageBucket: 'mechanic-9eef3.appspot.com',
    iosClientId: '698023764311-nndfq08adkg4fs93mmjnmqcd3c7233r6.apps.googleusercontent.com',
    iosBundleId: 'com.example.mechApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPDnX5dIVAZfZ121bGjwt7zyOVA_As8Gw',
    appId: '1:698023764311:ios:c66dceda01afff01c85e12',
    messagingSenderId: '698023764311',
    projectId: 'mechanic-9eef3',
    storageBucket: 'mechanic-9eef3.appspot.com',
    iosClientId: '698023764311-nndfq08adkg4fs93mmjnmqcd3c7233r6.apps.googleusercontent.com',
    iosBundleId: 'com.example.mechApp',
  );
}