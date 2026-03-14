import '../entities/notification_settings.dart';
import '../repos/notifications_repo.dart';

class SaveNotificationSettingsUseCase {
  final NotificationsRepo repo;
  SaveNotificationSettingsUseCase(this.repo);

  /// حفظ إعدادات الإشعارات المُحدَّثة
  Future<void> call(NotificationSettings settings) =>
      repo.saveNotificationSettings(settings);
}
