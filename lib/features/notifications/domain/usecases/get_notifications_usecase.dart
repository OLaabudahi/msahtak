import '../entities/notification_item.dart';
import '../repos/notifications_repo.dart';

class GetNotificationsUseCase {
  final NotificationsRepo repo;
  GetNotificationsUseCase(this.repo);

  /// ط¬ظ„ط¨ ط¬ظ…ظٹط¹ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ظ…ظ† ط§ظ„ظ…ط³طھظˆط¯ط¹
  Future<List<NotificationItem>> call() => repo.getNotifications();
}


