import '../services/profile_usage_firebase_service.dart';

class ProfileUsageSource {
  final ProfileUsageFirebaseService firebaseService;

  ProfileUsageSource(this.firebaseService);

  Future<List<Map<String, dynamic>>> getUserBookings() {
    return firebaseService.getUserBookings();
  }

  Future<List<Map<String, dynamic>>> getSpacesByIds(List<String> ids) {
    return firebaseService.getSpacesByIds(ids);
  }
}
