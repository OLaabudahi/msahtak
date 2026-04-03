import '../repos/profile_repo.dart';

class ChangePasswordUseCase {
  final ProfileRepo repo;

  ChangePasswordUseCase(this.repo);

  Future<void> call() {
    return repo.changePassword();
  }
}