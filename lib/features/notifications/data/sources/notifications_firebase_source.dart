import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/api/notification_api_service.dart';
import '../../../../core/services/firebase/firebase_messaging_service.dart';
import '../../../../core/services/firestore_api.dart';
import '../../domain/entities/notification_item.dart';
import '../models/notification_item_model.dart';
import '../models/notification_settings_model.dart';
import 'notifications_remote_source.dart';

class NotificationsFirebaseSource implements NotificationsRemoteSource {
  static const _kBookingApproved = 'notif_bookingApproved';
  static const _kBookingRejected = 'notif_bookingRejected';
  static const _kBookingReminder = 'notif_bookingReminder';
  static const _kOfferSuggestion = 'notif_offerSuggestion';
  static const _kReminderTiming = 'notif_reminderTiming';

  final FirestoreApi api = FirestoreApi();
  final NotificationApiService _notificationApiService = NotificationApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessagingService _messagingService =
      FirebaseMessagingService.instance;

  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    List<Map<String, dynamic>> docs = [];

    try {
      docs = await api.queryWhereEqual(
        collection: 'notifications',
        field: 'userId',
        value: uid,
      );
    } catch (_) {}

    if (docs.isEmpty) {
      try {
        docs = await api.queryWhereEqual(
          collection: 'notifications',
          field: 'user_id',
          value: uid,
        );
      } catch (_) {}
    }

    docs.sort((a, b) {
      final aTs = a['createdAt'] ?? a['created_at'];
      final bTs = b['createdAt'] ?? b['created_at'];
      if (aTs is Timestamp && bTs is Timestamp) return bTs.compareTo(aTs);
      return 0;
    });

    return docs.map((d) {
      final isRead = d['isRead'] as bool? ?? d['is_read'] as bool? ?? false;
      final subtitle = d['subtitle'] as String? ??
          d['body'] as String? ??
          d['message'] as String? ??
          '';
      final ts = d['createdAt'] as Timestamp? ?? d['created_at'] as Timestamp?;
      return NotificationItemModel(
        id: d['id'],
        title: d['title'] as String? ?? '',
        subtitle: subtitle,
        time: _relativeTime(ts),
        type: NotificationType.values.firstWhere(
          (e) => e.name == (d['type'] as String? ?? ''),
          orElse: () => NotificationType.tip,
        ),
        isRead: isRead,
        bookingId: d['bookingId'] as String? ??
            d['requestId'] as String? ??
            d['request_id'] as String?,
      );
    }).toList();
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final sp = await SharedPreferences.getInstance();
    var model = NotificationSettingsModel(
      bookingApproved: sp.getBool(_kBookingApproved) ?? true,
      bookingRejected: sp.getBool(_kBookingRejected) ?? true,
      bookingReminder: sp.getBool(_kBookingReminder) ?? false,
      offerSuggestion: sp.getBool(_kOfferSuggestion) ?? true,
      reminderTiming: sp.getInt(_kReminderTiming) ?? 0,
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final snap = await _firestore
            .collection('users')
            .doc(uid)
            .collection('settings')
            .doc('notifications')
            .get();
        final data = snap.data();
        if (data != null && data.isNotEmpty) {
          model = NotificationSettingsModel(
            bookingApproved:
                data['bookingApproved'] as bool? ?? model.bookingApproved,
            bookingRejected:
                data['bookingRejected'] as bool? ?? model.bookingRejected,
            bookingReminder:
                data['bookingReminder'] as bool? ?? model.bookingReminder,
            offerSuggestion:
                data['offerSuggestion'] as bool? ?? model.offerSuggestion,
            reminderTiming:
                data['reminderTiming'] as int? ?? model.reminderTiming,
          );
        }
      } catch (_) {}
    }

    return model;
  }

  @override
  Future<void> saveNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kBookingApproved, settings.bookingApproved);
    await sp.setBool(_kBookingRejected, settings.bookingRejected);
    await sp.setBool(_kBookingReminder, settings.bookingReminder);
    await sp.setBool(_kOfferSuggestion, settings.offerSuggestion);
    await sp.setInt(_kReminderTiming, settings.reminderTiming);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final bookingNotifications = settings.bookingApproved ||
            settings.bookingRejected ||
            settings.bookingReminder;
        final enableNotifications =
            bookingNotifications || settings.offerSuggestion;

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('settings')
            .doc('notifications')
            .set({
          'enable_notifications': enableNotifications,
          'booking_notifications': bookingNotifications,
          'bookingApproved': settings.bookingApproved,
          'bookingRejected': settings.bookingRejected,
          'bookingReminder': settings.bookingReminder,
          'offerSuggestion': settings.offerSuggestion,
          'reminderTiming': settings.reminderTiming,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  }) {
    return _notificationApiService.sendBookingNotification(
      userId: userId,
      bookingId: bookingId,
      title: title,
      body: body,
    );
  }

  @override
  Future<String?> getFcmToken() => _messagingService.getFcmToken();

  @override
  Future<void> saveFcmToken(String token) =>
      _messagingService.saveTokenForCurrentUser(token);

  @override
  Stream<Map<String, dynamic>> listenNotifications() =>
      _messagingService.listenNotifications();



  @override
  Future<void> markAllAsRead() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final byUserId = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .get();

    final byLegacyUserId = await _firestore
        .collection('notifications')
        .where('user_id', isEqualTo: uid)
        .get();

    final batch = _firestore.batch();
    for (final doc in [...byUserId.docs, ...byLegacyUserId.docs]) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  String _relativeTime(Timestamp? ts) {
    if (ts == null) return '--';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return '1d';
    return '${diff.inDays}d';
  }
}
