import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();

    final token = await _fcm.getToken();
    print("FCM TOKEN: $token");

    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground notification: ${message.notification?.title}");
    });
  }
}

