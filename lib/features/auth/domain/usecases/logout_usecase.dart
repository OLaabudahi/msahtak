import '../repos/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo repo;

  LogoutUseCase(this.repo);

  Future<void> call() {
    return repo.logout();
  }
}
/*
import '../repos/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo repo;

  LogoutUseCase(this.repo);

  Future call() {
    return repo.logout();
  }
}
*/


