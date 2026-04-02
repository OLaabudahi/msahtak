class RoleMapper {
  static String map(String? role) {
    switch (role) {
      case 'admin':
      case 'owner':
        return 'admin';

      case 'sub_admin':
      case 'assistant':
        return 'sub_admin';

      default:
        return 'user';
    }
  }

  static bool isOwner(String? role) {
    return map(role) == 'admin';
  }

  static bool isAssistant(String? role) {
    return map(role) == 'sub_admin';
  }

  static bool isUser(String? role) {
    return map(role) == 'user';
  }
}