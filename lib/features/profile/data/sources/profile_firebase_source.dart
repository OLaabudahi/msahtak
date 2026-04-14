import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/supabase_image_upload_service.dart';
import '../../../../core/services/firestore_api.dart';
import '../services/profile_stats_firebase_service.dart';

class ProfileFirebaseSource {
  final FirestoreApi firestoreApi;
  final ProfileStatsFirebaseService profileStatsService;
  final SupabaseImageUploadService imageUploadService;

  ProfileFirebaseSource(
    this.firestoreApi, {
    ProfileStatsFirebaseService? profileStatsService,
    SupabaseImageUploadService? imageUploadService,
  }) : profileStatsService =
           profileStatsService ?? ProfileStatsFirebaseService(),
       imageUploadService = imageUploadService ?? SupabaseImageUploadService();

  /// 🔥 fetch profile
  Future<Map<String, dynamic>> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

    final stats = await profileStatsService.fetchProfileStats(user.uid);

    final data = await firestoreApi.getDoc(
      collection: 'users',
      docId: user.uid,
    );

    return {
      ...?data,
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'isEmailVerified': user.emailVerified,
      ...stats,
    };
  }

  /// 🔥 update profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

    await user.updateDisplayName(name);

    if (user.email != email) {
      await user.updateEmail(email);
    }

    await firestoreApi.updateFields(
      collection: 'users',
      docId: user.uid,
      data: {
        'fullName': name,
        'email': email,
        'phoneNumber': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      },
    );
  }

  Future<String> uploadProfileImage(XFile file) {
    return imageUploadService.uploadImage(
      file: file,
      bucket: 'image_masahtak',
    );
  }

  /// 🔐 change password
  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: user.email!,
    );
  }

  /// 📩 verify email
  Future<void> verifyEmail() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

    await user.sendEmailVerification();
  }
  Future<void> refreshUser() async {
    await FirebaseAuth.instance.currentUser?.reload();

  }
  Future<void> syncEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

    await user.reload();

    final isVerified = user.emailVerified;

    await firestoreApi.updateFields(
      collection: 'users',
      docId: user.uid,
      data: {
        'isEmailVerified': isVerified,
      },
    );
  }

}
