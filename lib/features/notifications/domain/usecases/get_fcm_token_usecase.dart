import '../repos/notifications_repo.dart';

class GetFcmTokenUseCase {
  final NotificationsRepo repo;
  GetFcmTokenUseCase(this.repo);

  Future<String?> call() => repo.getFcmToken();
}
