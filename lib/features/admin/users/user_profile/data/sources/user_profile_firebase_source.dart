import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_source.dart';
import '../models/user_profile_model.dart';

/// ظ…طµط¯ط± Firebase ظ„ظ…ظ„ظپ ط§ظ„ظ…ط³طھط®ط¯ظ…
class UserProfileFirebaseSource implements UserProfileSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<UserProfileModel> fetchProfile({required String userId}) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    final d = userDoc.data() ?? {};
    final name = d['fullName'] as String? ?? d['full_name'] as String? ?? 'User';

    final bookingsSnap = await _db.collection('bookings').where('userId', isEqualTo: userId).get();
    final bookingIds = bookingsSnap.docs.map((b) => b.id).toList();
    final noShows = bookingsSnap.docs.where((b) {
      final s = (b.data()['status'] as String? ?? '').toLowerCase();
      return s == 'no_show' || s == 'noshow';
    }).length;

    return UserProfileModel(
      id: userId,
      name: name,
      avatar: _initials(name),
      internalRating: d['internalRating']?.toString() ?? '-',
      noShowCount: noShows.toString(),
      bookingHistory: bookingIds,
    );
  }

  @override
  Future<void> approveUser({required String userId}) async =>
      _db.collection('users').doc(userId).update({'status': 'active'});

  @override
  Future<void> blockUser({required String userId}) async =>
      _db.collection('users').doc(userId).update({'status': 'blocked'});

  @override
  Future<void> addNote({required String userId, required String note}) async =>
      _db.collection('users').doc(userId).update({'adminNotes': FieldValue.arrayUnion([note])});

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}


