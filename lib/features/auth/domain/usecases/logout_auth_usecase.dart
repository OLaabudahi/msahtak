import '../repos/auth_repo.dart';

class LogoutAuthUseCase {
  final AuthRepo repo;

  LogoutAuthUseCase(this.repo);

  Future call() {
    return repo.logout();
  }
}