import '../repos/user_profile_repo.dart';

class BlockUserUseCase {
  final UserProfileRepo repo;
  const BlockUserUseCase(this.repo);

  Future<void> call({required String userId}) => repo.blockUser(userId: userId);
}
