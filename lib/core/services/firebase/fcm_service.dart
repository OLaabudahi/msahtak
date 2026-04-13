import 'package:flutter/material.dart';

import 'firebase_messaging_service.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  void attachNavigatorKey(GlobalKey<NavigatorState> key) {
    FirebaseMessagingService.instance.attachNavigatorKey(key);
  }

  Future<void> init() {
    return FirebaseMessagingService.instance.init();
  }
}
