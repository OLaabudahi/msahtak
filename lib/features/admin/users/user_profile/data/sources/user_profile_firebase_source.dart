import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_source.dart';
import '../models/user_profile_model.dart';

/// مصدر Firebase لملف تعريف المستخدم
class UserProfileFirebaseSource implements UserProfileSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<UserProfileModel> fetchProfile({required String userId}) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) {
      return UserProfileModel(
        id: userId, name: 'Unknown', avatar: '?',
        internalRating: '0', noShowCount: '0',
        bookingHistory: const [],
      );
    }
    final d = doc.data()!;
    final name = d['fullName'] as String? ?? d['full_name'] as String? ?? 'User';

    // جلب الحجوزات بدون orderBy لتجنب composite index
    final bookingsSnap = await _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .limit(20)
        .get();

    final bookingIds = bookingsSnap.docs.map((e) => e.id).toList();
    final noShowCount = bookingsSnap.docs
        .where((e) => (e.data()['status'] as String?) == 'canceled')
        .length;

    return UserProfileModel(
      id: userId,
      name: name,
      avatar: _initials(name),
      internalRating: (d['rating'] as num?)?.toStringAsFixed(1) ?? '5.0',
      noShowCount: noShowCount.toString(),
      bookingHistory: bookingIds,
    );
  }

  @override
  Future<void> approveUser({required String userId}) async {
    await _db.collection('users').doc(userId).update({
      'status': 'active',
      'flagged': false,
    });
  }

  @override
  Future<void> blockUser({required String userId}) async {
    await _db.collection('users').doc(userId).update({
      'status': 'blocked',
    });
  }

  @override
  Future<void> addNote({required String userId, required String note}) async {
    await _db.collection('users').doc(userId).update({
      'adminNote': note,
      'noteUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
