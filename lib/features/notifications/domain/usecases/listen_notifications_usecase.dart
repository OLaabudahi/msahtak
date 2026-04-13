import '../repos/notifications_repo.dart';

class ListenNotificationsUseCase {
  final NotificationsRepo repo;
  ListenNotificationsUseCase(this.repo);

  Stream<Map<String, dynamic>> call() => repo.listenNotifications();
}
