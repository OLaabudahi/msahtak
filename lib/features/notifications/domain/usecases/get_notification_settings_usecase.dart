import '../entities/notification_settings.dart';
import '../repos/notifications_repo.dart';

class GetNotificationSettingsUseCase {
  final NotificationsRepo repo;
  GetNotificationSettingsUseCase(this.repo);

  
  Future<NotificationSettings> call() => repo.getNotificationSettings();
}
