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
    apiKey: 'AIzaSyCL6HEFldk5b7NKTH2CfjSzJKF-mCBjeWU',
    appId: '1:56727432724:web:0f98e0c364589618088101',
    messagingSenderId: '56727432724',
    projectId: 'praktikum-mobile-kel3-b1e1c',
    authDomain: 'praktikum-mobile-kel3-b1e1c.firebaseapp.com',
    storageBucket: 'praktikum-mobile-kel3-b1e1c.appspot.com',
    measurementId: 'G-XTW0GMG69H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFxG8JdXAhcU3pYd7a3kD3B9XKuM1psW8',
    appId: '1:56727432724:android:2b4dbb905a395f6d088101',
    messagingSenderId: '56727432724',
    projectId: 'praktikum-mobile-kel3-b1e1c',
    storageBucket: 'praktikum-mobile-kel3-b1e1c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUthId3Sbm8oLam8IM298_lc3jv9zFzC8',
    appId: '1:56727432724:ios:886aab899d6e4c7a088101',
    messagingSenderId: '56727432724',
    projectId: 'praktikum-mobile-kel3-b1e1c',
    storageBucket: 'praktikum-mobile-kel3-b1e1c.appspot.com',
    androidClientId: '56727432724-d20vef1klmbf7pah3gcdijdc9v5chsbc.apps.googleusercontent.com',
    iosClientId: '56727432724-ctepc2i7sbvtgadv3jsdoktgg20j4anu.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectPraktikumMobileKel3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUthId3Sbm8oLam8IM298_lc3jv9zFzC8',
    appId: '1:56727432724:ios:886aab899d6e4c7a088101',
    messagingSenderId: '56727432724',
    projectId: 'praktikum-mobile-kel3-b1e1c',
    storageBucket: 'praktikum-mobile-kel3-b1e1c.appspot.com',
    androidClientId: '56727432724-d20vef1klmbf7pah3gcdijdc9v5chsbc.apps.googleusercontent.com',
    iosClientId: '56727432724-ctepc2i7sbvtgadv3jsdoktgg20j4anu.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectPraktikumMobileKel3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCL6HEFldk5b7NKTH2CfjSzJKF-mCBjeWU',
    appId: '1:56727432724:web:c131c8bddfd2f339088101',
    messagingSenderId: '56727432724',
    projectId: 'praktikum-mobile-kel3-b1e1c',
    authDomain: 'praktikum-mobile-kel3-b1e1c.firebaseapp.com',
    storageBucket: 'praktikum-mobile-kel3-b1e1c.appspot.com',
    measurementId: 'G-2L17QYET30',
  );

}