import '../entities/notification_settings.dart';
import '../repos/notifications_repo.dart';

class GetNotificationSettingsUseCase {
  final NotificationsRepo repo;
  GetNotificationSettingsUseCase(this.repo);

  /// جلب إعدادات الإشعارات الحالية
  Future<NotificationSettings> call() => repo.getNotificationSettings();
}
