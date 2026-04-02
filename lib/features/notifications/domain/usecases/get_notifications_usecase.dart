import '../entities/notification_item.dart';
import '../repos/notifications_repo.dart';

class GetNotificationsUseCase {
  final NotificationsRepo repo;
  GetNotificationsUseCase(this.repo);

  
  Future<List<NotificationItem>> call() => repo.getNotifications();
}
