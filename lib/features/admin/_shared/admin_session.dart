import '../../../services/local_storage_service.dart';

/// ط¬ظ„ط³ط© ط§ظ„ط£ط¯ظ…ظ† â€” طھظڈط­ظ…ظ‘ظ„ ظ…ط±ط© ظˆط§ط­ط¯ط© ط¹ظ†ط¯ ط¯ط®ظˆظ„ ظˆط§ط¬ظ‡ط© ط§ظ„ط£ط¯ظ…ظ† ظˆطھط¨ظ‚ظ‰ ط·ظˆط§ظ„ ط§ظ„ط¬ظ„ط³ط©
class AdminSession {
  AdminSession._();

  static String userId = '';
  static String userName = '';
  static String role = '';

  static List<String> assignedSpaceIds = [];

  static bool get isSuperAdmin => role == 'admin' || role == 'super_admin';
  static bool get isSubAdmin => role == 'sub_admin';

  /// طھط­ظ…ظٹظ„ ط¨ظٹط§ظ†ط§طھ ط§ظ„ط£ط¯ظ…ظ† ظ…ظ† LocalStorage
  static Future<void> load() async {

    final storage = LocalStorageService();

    userId = await storage.getUserId() ?? '';
    userName = await storage.getUserName() ?? '';

    role = await storage.getUserRole() ?? '';

    assignedSpaceIds = await storage.getAssignedSpaceIds();
  }

  static void clear() {
    userId = '';
    userName = '';
    role = '';
    assignedSpaceIds = [];
  }
}

