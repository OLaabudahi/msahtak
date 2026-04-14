import '../repos/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo repo;

  UpdateProfileUseCase(this.repo);

  Future<void> call({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) {
    return repo.updateProfile(
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}
