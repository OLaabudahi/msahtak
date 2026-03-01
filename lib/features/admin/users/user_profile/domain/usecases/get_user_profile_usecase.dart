import '../entities/user_profile_entity.dart';
import '../repos/user_profile_repo.dart';

class GetUserProfileUseCase {
  final UserProfileRepo repo;
  const GetUserProfileUseCase(this.repo);

  Future<UserProfileEntity> call({required String userId}) => repo.getProfile(userId: userId);
}
