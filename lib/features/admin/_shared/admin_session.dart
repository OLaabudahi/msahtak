import '../../../services/local_storage_service.dart';

/// جلسة الأدمن — تُحمّل مرة واحدة عند دخول واجهة الأدمن وتبقى طوال الجلسة
class AdminSession {
  AdminSession._();

  static String role = '';
  static List<String> assignedSpaceIds = [];

  static bool get isSuperAdmin => role == 'admin' || role == 'super_admin';
  static bool get isSubAdmin => role == 'sub_admin';

  /// تحميل الدور والمساحات المخصصة من SharedPreferences
  static Future<void> load() async {
    final storage = LocalStorageService();
    role = await storage.getUserRole() ?? '';
    assignedSpaceIds = await storage.getAssignedSpaceIds();
  }

  static void clear() {
    role = '';
    assignedSpaceIds = [];
  }
}
