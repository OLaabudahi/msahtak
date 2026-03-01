import '../repos/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo repo;
  const LogoutUseCase(this.repo);

  Future<void> call() {
    return repo.logout();
  }
}