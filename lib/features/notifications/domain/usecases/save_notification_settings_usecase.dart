import '../entities/notification_settings.dart';
import '../repos/notifications_repo.dart';

class SaveNotificationSettingsUseCase {
  final NotificationsRepo repo;
  SaveNotificationSettingsUseCase(this.repo);

  /// ط­ظپط¸ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ظ…ظڈط­ط¯ظژظ‘ط«ط©
  Future<void> call(NotificationSettings settings) =>
      repo.saveNotificationSettings(settings);
}


