import '../entities/notification_item.dart';
import '../entities/notification_settings.dart';

abstract class NotificationsRepo {
  /// جلب قائمة الإشعارات
  Future<List<NotificationItem>> getNotifications();

  /// جلب إعدادات الإشعارات
  Future<NotificationSettings> getNotificationSettings();

  /// حفظ إعدادات الإشعارات
  Future<void> saveNotificationSettings(NotificationSettings settings);
}
