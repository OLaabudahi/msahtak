import 'package:cloud_firestore/cloud_firestore.dart';
import 'users_source.dart';
import '../models/user_model.dart';

/// مصدر Firebase للمستخدمين — يقرأ من users collection
class UsersFirebaseSource implements UsersSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> fetchUsers() async {
    // جلب كل المستخدمين وفلترة الأدمن client-side لتجنب composite index
    final snap = await _db.collection('users').get();

    return snap.docs.where((doc) {
      final role = (doc.data()['role'] as String? ?? '').toLowerCase();
      return role != 'admin';
    }).map((doc) {
      final d = doc.data();
      final name = d['fullName'] as String? ?? d['full_name'] as String? ?? 'User';
      final status = d['status'] as String? ?? 'active';
      final flagged = d['flagged'] as bool? ?? false;
      return UserModel(
        id: doc.id,
        name: name,
        avatar: _initials(name),
        status: status,
        flagged: flagged,
      );
    }).toList();
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
