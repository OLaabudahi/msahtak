import '../entities/notification_settings.dart';
import '../repos/notifications_repo.dart';

class GetNotificationSettingsUseCase {
  final NotificationsRepo repo;
  GetNotificationSettingsUseCase(this.repo);

  /// ط¬ظ„ط¨ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ط­ط§ظ„ظٹط©
  Future<NotificationSettings> call() => repo.getNotificationSettings();
}


