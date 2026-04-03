import '../repos/profile_repo.dart';

class VerifyEmailUseCase {
  final ProfileRepo repo;

  VerifyEmailUseCase(this.repo);

  Future<void> call() {
    return repo.verifyEmail();
  }
}