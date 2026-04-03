import '../repos/profile_repo.dart';

class SyncEmailVerificationUseCase {
  final ProfileRepo repo;

  SyncEmailVerificationUseCase(this.repo);

  Future<void> call() {
    return repo.syncEmailVerification();
  }
}