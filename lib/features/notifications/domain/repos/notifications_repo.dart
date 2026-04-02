import '../entities/notification_item.dart';
import '../entities/notification_settings.dart';

abstract class NotificationsRepo {
  
  Future<List<NotificationItem>> getNotifications();

  
  Future<NotificationSettings> getNotificationSettings();

  
  Future<void> saveNotificationSettings(NotificationSettings settings);
}
