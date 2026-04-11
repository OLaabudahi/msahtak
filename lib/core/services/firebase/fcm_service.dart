import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/di/app_injector.dart';
import '../../../features/booking_request/view/booking_request_routes.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GlobalKey<NavigatorState>? _navigatorKey;
  String? _pendingBookingIdFromPush;
  bool _initialized = false;

  void attachNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
    _flushPendingNavigation();
  }

  Future<void> init() async {
    if (_initialized) return;

    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM] Foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('[FCM] Opened from notification: ${message.messageId}');
      _handleNotificationOpen(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }

    await _syncTokenForCurrentUser();

    _messaging.onTokenRefresh.listen((token) async {
      await _saveToken(token);
    });

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await _syncTokenForCurrentUser();
      if (user != null) {
        _flushPendingNavigation();
      }
    });

    _initialized = true;
  }

  void _handleNotificationOpen(RemoteMessage message) {
    final data = message.data;
    final bookingId = (data['bookingId'] ??
            data['requestId'] ??
            data['request_id'])?.toString();
    if (bookingId == null || bookingId.isEmpty) return;

    _openBookingStatus(bookingId);
  }

  void _openBookingStatus(String bookingId) {
    if (FirebaseAuth.instance.currentUser == null) {
      _pendingBookingIdFromPush = bookingId;
      return;
    }

    final nav = _navigatorKey?.currentState;
    if (nav == null) {
      _pendingBookingIdFromPush = bookingId;
      return;
    }

    nav.push(
      BookingRequestRoutes.bookingStatus(
        bloc: AppInjector.createBookingBloc(),
        bookingId: bookingId,
      ),
    );
  }

  void _flushPendingNavigation() {
    final id = _pendingBookingIdFromPush;
    if (id == null || id.isEmpty) return;
    if (FirebaseAuth.instance.currentUser == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 150), () {
        if (_navigatorKey?.currentState == null) return;
        if (FirebaseAuth.instance.currentUser == null) return;
        _pendingBookingIdFromPush = null;
        _openBookingStatus(id);
      });
    });
  }

  Future<void> _syncTokenForCurrentUser() async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;
    await _saveToken(token);
  }

  Future<void> _saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('[FCM] skip token save: no signed-in user.');
      return;
    }

    final uid = user.uid;
    final platform = _platformName();
    final deviceDocId = _buildDeviceDocId(uid: uid, platform: platform);

    final userPayload = {
      'fcmTokens': FieldValue.arrayUnion([token]),
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      'lastPlatform': platform,
    };

    final devicePayload = {
      'uid': uid,
      'token': token,
      'platform': platform,
      'app': 'mobile',
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('users').doc(uid).set(
      userPayload,
      SetOptions(merge: true),
    );

    await _firestore.collection('user_devices').doc(deviceDocId).set(
      devicePayload,
      SetOptions(merge: true),
    );

    await _cleanupDuplicatedDeviceDocs(
      uid: uid,
      platform: platform,
      currentDocId: deviceDocId,
    );

    debugPrint('[FCM] token synced for uid=$uid on $platform');
  }

  String _buildDeviceDocId({required String uid, required String platform}) {
    return '${uid}_${platform}_mobile';
  }

  Future<void> _cleanupDuplicatedDeviceDocs({
    required String uid,
    required String platform,
    required String currentDocId,
  }) async {
    final snapshot = await _firestore
        .collection('user_devices')
        .where('uid', isEqualTo: uid)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    var hasChanges = false;

    for (final doc in snapshot.docs) {
      if (doc.id == currentDocId) continue;
      final data = doc.data();
      final docPlatform = (data['platform'] ?? '').toString();
      final docApp = (data['app'] ?? '').toString();
      if (docPlatform != platform || docApp != 'mobile') continue;
      batch.delete(doc.reference);
      hasChanges = true;
    }

    if (hasChanges) {
      await batch.commit();
      debugPrint(
        '[FCM] cleaned duplicated device docs for uid=$uid on $platform',
      );
    }
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'unknown';
    }
  }
}
