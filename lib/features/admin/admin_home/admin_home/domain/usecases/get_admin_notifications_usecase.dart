import '../entities/admin_notification_item.dart';
import '../repos/admin_home_repo.dart';

class GetAdminNotificationsUseCase {
  final AdminHomeRepo repo;
  const GetAdminNotificationsUseCase(this.repo);

  Future<List<AdminNotificationItem>> call() => repo.getNotifications();
}
