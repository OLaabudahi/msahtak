import '../repos/notifications_repo.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationsRepo repo;

  const MarkAllNotificationsReadUseCase(this.repo);

  Future<void> call() {
    return repo.markAllAsRead();
  }
}
