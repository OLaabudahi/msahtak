import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repos/user_profile_repo.dart';
import '../sources/user_profile_source.dart';

class UserProfileRepoImpl implements UserProfileRepo {
  final UserProfileSource source;
  const UserProfileRepoImpl(this.source);

  @override
  Future<UserProfileEntity> getProfile({required String userId}) async {
    final m = await source.fetchProfile(userId: userId);
    return m.toEntity();
  }

  @override
  Future<void> approveUser({required String userId}) => source.approveUser(userId: userId);

  @override
  Future<void> blockUser({required String userId}) => source.blockUser(userId: userId);

  @override
  Future<void> addNote({required String userId, required String note}) => source.addNote(userId: userId, note: note);
}
