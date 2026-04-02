import '../entities/notification_item.dart';
import '../entities/notification_settings.dart';

abstract class NotificationsRepo {
  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ
  Future<List<NotificationItem>> getNotifications();

  /// ط¬ظ„ط¨ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ
  Future<NotificationSettings> getNotificationSettings();

  /// ط­ظپط¸ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ
  Future<void> saveNotificationSettings(NotificationSettings settings);
}


