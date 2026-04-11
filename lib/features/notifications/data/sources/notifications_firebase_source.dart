import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firestore_api.dart';
import '../../domain/entities/notification_item.dart';
import '../models/notification_item_model.dart';
import '../models/notification_settings_model.dart';
import 'notifications_remote_source.dart';

/// ✅ تنفيذ Firebase لـ NotificationsRemoteSource
class NotificationsFirebaseSource implements NotificationsRemoteSource {
  static const _kBookingApproved = 'notif_bookingApproved';
  static const _kBookingRejected = 'notif_bookingRejected';
  static const _kBookingReminder = 'notif_bookingReminder';
  static const _kOfferSuggestion = 'notif_offerSuggestion';
  static const _kReminderTiming = 'notif_reminderTiming';
  final FirestoreApi api = FirestoreApi();

  @override
  Future<List<NotificationItemModel>> getNotifications() async {

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
/*
    // الأدمن يكتب userId (camelCase) – نجرب الاثنين
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: uid)
          .limit(50)
          .get();
    } catch (_) {
      snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('user_id', isEqualTo: uid)
          .limit(50)
          .get();
    }

    // إذا لم نجد بـ userId نجرب user_id
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snap.docs;
    if (docs.isEmpty) {
      try {
        final snap2 = await FirebaseFirestore.instance
            .collection('notifications')
            .where('user_id', isEqualTo: uid)
            .limit(50)
            .get();
        docs = snap2.docs;
      } catch (_) {}
    }
*/
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
    /*docs.sort((a, b) {
      final aTs = a.data()['createdAt'] ?? a.data()['created_at'];
      final bTs = b.data()['createdAt'] ?? b.data()['created_at'];*/
    docs.sort((a, b) {
      final aTs = a['createdAt'] ?? a['created_at'];
      final bTs = b['createdAt'] ?? b['created_at'];
      if (aTs is Timestamp && bTs is Timestamp) return bTs.compareTo(aTs);
      return 0;
    });

  /*  return docs.map((doc) {
      final d = doc.data();*/
    return docs.map((d) {
      // Keep backward compatibility: web may write `isRead`, old app reads `is_read`.
      final isRead = d['isRead'] as bool? ?? d['is_read'] as bool? ?? false;
      // الأدمن يكتب message ، التطبيق يقرأ subtitle ثم body
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
    return NotificationSettingsModel(
      bookingApproved: sp.getBool(_kBookingApproved) ?? true,
      bookingRejected: sp.getBool(_kBookingRejected) ?? true,
      bookingReminder: sp.getBool(_kBookingReminder) ?? false,
      offerSuggestion: sp.getBool(_kOfferSuggestion) ?? true,
      reminderTiming: sp.getInt(_kReminderTiming) ?? 0,
    );
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
  }

  String _relativeTime(Timestamp? ts) {
    if (ts == null) return '--';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d';
  }
}
