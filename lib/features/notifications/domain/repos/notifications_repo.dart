import '../entities/notification_item.dart';
import '../entities/notification_settings.dart';

abstract class NotificationsRepo {
  /// جلب قائمة الإشعارات
  Future<List<NotificationItem>> getNotifications();

  /// جلب إعدادات الإشعارات
  Future<NotificationSettings> getNotificationSettings();

  /// حفظ إعدادات الإشعارات
  Future<void> saveNotificationSettings(NotificationSettings settings);
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
