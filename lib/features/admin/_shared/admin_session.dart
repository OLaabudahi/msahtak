import '../../../services/local_storage_service.dart';

class AdminSession {
  AdminSession._();

  static final LocalStorageService _storage = LocalStorageService();

  static String get userId => _storage.cachedAdminSession.userId;
  static String get userName => _storage.cachedAdminSession.userName;
  static String get role => _storage.cachedAdminSession.role;
  static List<String> get assignedSpaceIds =>
      _storage.cachedAdminSession.assignedSpaceIds;

  static bool get isSuperAdmin => role == 'admin' || role == 'super_admin';
  static bool get isSubAdmin => role == 'sub_admin' || role == 'sup_admin';

  static Future<void> load() async {
    await _storage.loadAdminSession();
  }

  static void clear() {
    _storage.clearAdminSessionCache();
  }
}
