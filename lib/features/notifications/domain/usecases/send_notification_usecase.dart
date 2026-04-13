import '../repos/notifications_repo.dart';

class SendNotificationUseCase {
  final NotificationsRepo repo;
  SendNotificationUseCase(this.repo);

  Future<void> call({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  }) {
    return repo.sendNotification(
      userId: userId,
      bookingId: bookingId,
      title: title,
      body: body,
    );
  }
}
