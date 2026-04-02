import '../repos/auth_repo.dart';

class ForgotPasswordUseCase {
  final AuthRepo repo;

  ForgotPasswordUseCase(this.repo);

  Future call(String email) {
    return repo.requestPasswordReset(email: email);
  }
}