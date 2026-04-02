import '../entities/user_profile_entity.dart';

abstract class UserProfileRepo {
  Future<UserProfileEntity> getProfile({required String userId});
  Future<void> approveUser({required String userId});
  Future<void> blockUser({required String userId});
  Future<void> addNote({required String userId, required String note});
}


