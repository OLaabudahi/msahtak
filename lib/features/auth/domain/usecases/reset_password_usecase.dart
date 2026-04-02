import '../repos/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo repo;

  ResetPasswordUseCase(this.repo);

  Future<void> call(String email) {
    return repo.requestPasswordReset(email: email);
  }
}

