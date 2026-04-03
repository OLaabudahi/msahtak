import '../entities/user_entity.dart';
import '../repos/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo repo;

  GetProfileUseCase(this.repo);

  Future<UserEntity> call() async {
    final model = await repo.fetchProfile();
    return model.toEntity();
  }
}