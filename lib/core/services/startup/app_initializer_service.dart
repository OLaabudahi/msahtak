import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../navigation/app_navigator.dart';
import '../../../firebase_options.dart';
import '../firebase/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class AppInitializerService {
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FCMService.instance.attachNavigatorKey(AppNavigator.key);
    unawaited(FCMService.instance.init());

    _isInitialized = true;
  }
}
