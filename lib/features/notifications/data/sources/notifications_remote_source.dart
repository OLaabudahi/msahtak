import '../../domain/entities/notification_item.dart';
import '../models/notification_item_model.dart';
import '../models/notification_settings_model.dart';

/// واجهة مصدر البيانات – استبدل FakeNotificationsSource بـ RealNotificationsSource عند ربط API
abstract class NotificationsRemoteSource {
  Future<List<NotificationItemModel>> getNotifications();
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettingsModel settings);
  Future<void> sendNotification({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  });
  Future<String?> getFcmToken();
  Future<void> saveFcmToken(String token);
  Stream<Map<String, dynamic>> listenNotifications();

  Future<void> markAllAsRead();
}

class FakeNotificationsSource implements NotificationsRemoteSource {
  /// جلب بيانات الإشعارات التجريبية – استبدل بـ http.get() عند ربط API
  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      // --- TODAY (isRead: false) ---
      NotificationItemModel(
        id: '1',
        title: 'Booking approved',
        subtitle: 'Downtown Hub confirmed your request.',
        time: '2m',
        type: NotificationType.bookingApproved,
        isRead: false,
      ),
      NotificationItemModel(
        id: '2',
        title: 'Reminder before booking',
        subtitle: 'Your session starts in 30 minutes.',
        time: '45m',
        type: NotificationType.reminder,
        isRead: false,
      ),
      NotificationItemModel(
        id: '3',
        title: 'Offer / plan suggestion',
        subtitle: 'Weekly plan could save you 18% for this space.',
        time: '1h',
        type: NotificationType.offerSuggestion,
        isRead: false,
      ),
      // --- EARLIER (isRead: true) ---
      NotificationItemModel(
        id: '4',
        title: 'Booking rejected',
        subtitle: "City Study Room couldn't confirm your time.",
        time: 'Yesterday',
        type: NotificationType.bookingRejected,
        isRead: true,
      ),
      NotificationItemModel(
        id: '5',
        title: 'Tip',
        subtitle: 'You can track all requests in the Bookings tab.',
        time: '2d',
        type: NotificationType.tip,
        isRead: true,
      ),
    ];
  }

  /// جلب إعدادات الإشعارات التجريبية – استبدل بـ http.get() عند ربط API
  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const NotificationSettingsModel(
      bookingApproved: true,
      bookingRejected: true,
      bookingReminder: false,
      offerSuggestion: true,
      reminderTiming: 0,
    );
  }

  /// حفظ الإعدادات – استبدل بـ http.post() عند ربط API
  @override
  Future<void> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: POST /api/notification-settings body: settings.toJson()
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 80));
  }

  @override
  Future<String?> getFcmToken() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return null;
  }

  @override
  Future<void> saveFcmToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 80));
  }

  @override
  Stream<Map<String, dynamic>> listenNotifications() async* {}

  @override
  Future<void> markAllAsRead() async {}
}
