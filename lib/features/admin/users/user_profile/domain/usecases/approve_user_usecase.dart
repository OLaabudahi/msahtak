import '../repos/user_profile_repo.dart';

class ApproveUserUseCase {
  final UserProfileRepo repo;
  const ApproveUserUseCase(this.repo);

  Future<void> call({required String userId}) => repo.approveUser(userId: userId);
}


