import '../repos/admin_settings_repo.dart';

class LogoutUseCase {
  final AdminSettingsRepo repo;
  const LogoutUseCase(this.repo);

  Future<void> call() => repo.logout();
}
