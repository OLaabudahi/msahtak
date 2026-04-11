class RoleMapper {
  /// Keeps Firebase role values stable so web + mobile stay compatible.
  static String map(String? role) {
    switch (role?.trim().toLowerCase()) {
      case 'admin':
      case 'owner':
      case 'spaceowner':
      case 'space_owner':
        return 'admin';

      case 'sup_admin':
      case 'sub_admin':
      case 'assistant':
      case 'spaceassistant':
      case 'space_assistant':
        return 'sup_admin';

      case 'super_admin':
      case 'superadmin':
        return 'super_admin';

      default:
        return 'user';
    }
  }

  static bool isOwner(String? role) {
    final value = map(role);
    return value == 'admin' || value == 'super_admin';
  }

  static bool isAssistant(String? role) {
    return map(role) == 'sup_admin';
  }

  static bool isSuperAdmin(String? role) {
    return map(role) == 'super_admin';
  }

  static bool isUser(String? role) {
    return map(role) == 'user';
  }
}
