import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repos/profile_repo.dart';
import '../models/user_model.dart';
import '../sources/profile_firebase_source.dart';

class ProfileRepoFirebase implements ProfileRepo {
  final ProfileFirebaseSource source;

  ProfileRepoFirebase(this.source);

  @override
  Future<UserModel> fetchProfile() async {
    final d = await source.fetchProfile();

    return UserModel(
      userId: d['uid'],
      fullName: d['fullName'] ?? d['displayName'] ?? 'User',
      email: d['email'] ?? '',
      phoneNumber: d['phoneNumber'],
      avatarUrl: d['avatarUrl'],
      totalBookings: (d['totalBookings'] ?? 0),
      completedBookings: (d['completedBookings'] ?? 0),
      savedSpaces: (d['savedSpaces'] ?? 0),
      isEmailVerified:
          FirebaseAuth.instance.currentUser?.emailVerified ??
          d['isEmailVerified'] ??
          false,
    );
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    return source.updateProfile(name: name, email: email, phone: phone);
  }

  @override
  Future<void> changePassword() {
    return source.changePassword();
  }

  @override
  Future<void> verifyEmail() {
    return source.verifyEmail();
  }

  @override
  Future<void> syncEmailVerification() {
    throw source.syncEmailVerification();
  }
}
