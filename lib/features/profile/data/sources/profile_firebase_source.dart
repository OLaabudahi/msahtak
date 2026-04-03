import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firestore_api.dart';

class ProfileFirebaseSource {
  final FirestoreApi firestoreApi;

  ProfileFirebaseSource(this.firestoreApi);

  /// 🔥 fetch profile
  Future<Map<String, dynamic>> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not logged in');

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
    };
  }

  /// 🔥 update profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
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
      },
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