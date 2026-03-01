import '../repos/auth_repo.dart';

class RequestPasswordResetUseCase {
  final AuthRepo repo;
  const RequestPasswordResetUseCase(this.repo);

  Future<void> call({required String email}) {
    return repo.requestPasswordReset(email: email);
  }
}