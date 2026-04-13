import '../repos/notifications_repo.dart';

class SaveFcmTokenUseCase {
  final NotificationsRepo repo;
  SaveFcmTokenUseCase(this.repo);

  Future<void> call(String token) => repo.saveFcmToken(token);
}
