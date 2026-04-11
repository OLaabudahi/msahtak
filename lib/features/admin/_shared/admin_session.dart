import '../../../services/local_storage_service.dart';


class AdminSession {
  AdminSession._();

  static String userId = '';
  static String userName = '';
  static String role = '';
  static List<String> assignedSpaceIds = [];

  static bool get isSuperAdmin => role == 'admin' || role == 'super_admin';
  static bool get isSubAdmin => role == 'sub_admin' || role == 'sup_admin';


  static Future<void> load() async {
    final storage = LocalStorageService();
    userId = await storage.getUserId() ?? '';
    userName = await storage.getUserName() ?? '';
    print("USER ID: $userId");
    print("USER NAME: $userName");

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
