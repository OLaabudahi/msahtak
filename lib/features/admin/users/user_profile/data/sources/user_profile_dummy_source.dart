import 'user_profile_source.dart';
import '../models/user_profile_model.dart';

class UserProfileDummySource implements UserProfileSource {
  @override
  Future<UserProfileModel> fetchProfile({required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return UserProfileModel(
      id: userId,
      name: 'Mike Chen',
      avatar: 'MC',
      internalRating: '4.2',
      noShowCount: '1',
      bookingHistory: const ['b1', 'b4', 'b7'],
    );
  }

  @override
  Future<void> approveUser({required String userId}) async => Future<void>.delayed(const Duration(milliseconds: 120));

  @override
  Future<void> blockUser({required String userId}) async => Future<void>.delayed(const Duration(milliseconds: 120));

  @override
  Future<void> addNote({required String userId, required String note}) async => Future<void>.delayed(const Duration(milliseconds: 120));
}
