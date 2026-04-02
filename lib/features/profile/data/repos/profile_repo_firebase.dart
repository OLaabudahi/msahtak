import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repos/profile_repo.dart';
import '../models/user_model.dart';


class ProfileRepoFirebase implements ProfileRepo {
  @override
  Future<UserModel> fetchProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('Not logged in');

    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final d = doc.data() ?? {};

    return UserModel(
      userId: uid,
      fullName: d['fullName'] as String? ??
          d['full_name'] as String? ??
          FirebaseAuth.instance.currentUser?.displayName ??
          'User',
      email: d['email'] as String? ??
          FirebaseAuth.instance.currentUser?.email ??
          '',
      phoneNumber: d['phoneNumber'] as String? ?? d['phone_number'] as String?,
      avatarUrl: d['avatarUrl'] as String? ?? d['avatar_url'] as String?,
      totalBookings: (d['totalBookings'] as num?)?.toInt() ?? 0,
      completedBookings: (d['completedBookings'] as num?)?.toInt() ?? 0,
      savedSpaces: (d['savedSpaces'] as num?)?.toInt() ?? 0,
    );
  }
}
