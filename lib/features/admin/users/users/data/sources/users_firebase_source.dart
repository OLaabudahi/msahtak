import '../../../../../../core/services/firestore_api.dart';
import '../../../../../../services/local_storage_service.dart';

import 'users_source.dart';
import '../models/user_model.dart';

class UsersFirebaseSource implements UsersSource {
  final FirestoreApi _api = FirestoreApi();
  final LocalStorageService _storage = LocalStorageService();

  @override
  Future<List<UserModel>> fetchUsers() async {
    final adminId = await _storage.getUserId();

    /// =========================
    /// 1. جيب كل الحجوزات
    /// =========================
    final bookings = await _api.getCollection(collection: 'bookings');

    /// =========================
    /// 2. فلترة حسب adminId (🔥 المهم)
    /// =========================
    final userIds = bookings.where((b) {
      final space = b['space'] as Map<String, dynamic>? ?? {};
      final bookingAdminId = space['adminId'] ?? '';

      return bookingAdminId == adminId;
    }).map((b) {
      return b['userId'] as String?;
    }).whereType<String>().toSet(); // إزالة التكرار

    /// =========================
    /// 3. جيب كل المستخدمين
    /// =========================
    final users = await _api.getCollection(collection: 'users');

    /// =========================
    /// 4. فلترة المستخدمين
    /// =========================
    final filteredUsers = users.where((u) {
      return userIds.contains(u['id']);
    });

    /// =========================
    /// 5. تحويل لمودل
    /// =========================
    return filteredUsers.map((u) {
      final name =
          u['fullName'] ??
              u['full_name'] ??
              'User';

      final status = u['status'] ?? 'active';
      final flagged = u['flagged'] ?? false;

      return UserModel(
        id: u['id'],
        name: name,
        avatar: _initials(name),
        status: status,
        flagged: flagged,
      );
    }).toList();
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}