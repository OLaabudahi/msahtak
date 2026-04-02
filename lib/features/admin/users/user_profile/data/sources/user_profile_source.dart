import '../models/user_profile_model.dart';

abstract class UserProfileSource {
  Future<UserProfileModel> fetchProfile({required String userId});
  Future<void> approveUser({required String userId});
  Future<void> blockUser({required String userId});
  Future<void> addNote({required String userId, required String note});
}


