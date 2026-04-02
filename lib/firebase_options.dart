

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;











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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAAtRYqL1K7U2rOgZIl5Jkm6D1TCrjZIcA',
    appId: '1:698765384610:web:60e313ff90369edac570fb',
    messagingSenderId: '698765384610',
    projectId: 'masahatak-73bf9',
    authDomain: 'masahatak-73bf9.firebaseapp.com',
    databaseURL: 'https://masahatak-73bf9-default-rtdb.firebaseio.com',
    storageBucket: 'masahatak-73bf9.firebasestorage.app',
    measurementId: 'G-YC2G9XNZF8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpSCsM7rT4FPMNFS_rJyhsXPNozs5pNlo',
    appId: '1:698765384610:android:0efac148ad315b28c570fb',
    messagingSenderId: '698765384610',
    projectId: 'masahatak-73bf9',
    databaseURL: 'https://masahatak-73bf9-default-rtdb.firebaseio.com',
    storageBucket: 'masahatak-73bf9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbJRb7pihZgRRYoAzkBPZZWHH2CLErW3A',
    appId: '1:698765384610:ios:92bb23cda41ceaf6c570fb',
    messagingSenderId: '698765384610',
    projectId: 'masahatak-73bf9',
    databaseURL: 'https://masahatak-73bf9-default-rtdb.firebaseio.com',
    storageBucket: 'masahatak-73bf9.firebasestorage.app',
    iosBundleId: 'com.example.masahtakApp',
  );
}


