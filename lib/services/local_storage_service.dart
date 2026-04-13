import 'package:shared_preferences/shared_preferences.dart';

class AdminSessionData {
  const AdminSessionData({
    required this.userId,
    required this.userName,
    required this.role,
    required this.assignedSpaceIds,
  });

  final String userId;
  final String userName;
  final String role;
  final List<String> assignedSpaceIds;

  static const empty = AdminSessionData(
    userId: '',
    userName: '',
    role: '',
    assignedSpaceIds: <String>[],
  );
}

class LocalStorageService {
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();
  static final LocalStorageService _instance = LocalStorageService._internal();

  static const _kIsLoggedIn = 'is_logged_in';
  static const _kHasCompletedOnboarding = 'has_completed_onboarding';
  static const _kLocaleCode = 'locale_code';
  static const _kUserId = 'user_id';
  static const _kUserName = 'user_name';
  static const _kUserRole = 'user_role';
  static const _kAssignedSpaceIds = 'assigned_space_ids';

  AdminSessionData _cachedAdminSession = AdminSessionData.empty;

  AdminSessionData get cachedAdminSession => _cachedAdminSession;

  Future<bool> getIsLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kIsLoggedIn) ?? false;
  }

  Future<void> setIsLoggedIn(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kIsLoggedIn, value);
  }

  Future<bool> getHasCompletedOnboarding() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kHasCompletedOnboarding) ?? false;
  }

  Future<void> setHasCompletedOnboarding(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHasCompletedOnboarding, value);
  }

  Future<String?> getLocaleCode() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kLocaleCode);
  }

  Future<void> setLocaleCode(String code) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocaleCode, code);
  }

  Future<String?> getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserId);
  }

  Future<void> setUserId(String id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserId, id);
  }

  Future<String?> getUserName() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserName);
  }

  Future<void> setUserName(String name) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserName, name);
  }

  Future<String?> getUserRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserRole);
  }

  Future<void> setUserRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserRole, role);
  }

  Future<List<String>> getAssignedSpaceIds() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kAssignedSpaceIds) ?? [];
  }

  Future<void> setAssignedSpaceIds(List<String> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kAssignedSpaceIds, ids);
  }

  Future<AdminSessionData> loadAdminSession() async {
    _cachedAdminSession = AdminSessionData(
      userId: await getUserId() ?? '',
      userName: await getUserName() ?? '',
      role: await getUserRole() ?? '',
      assignedSpaceIds: await getAssignedSpaceIds(),
    );
    return _cachedAdminSession;
  }

  void clearAdminSessionCache() {
    _cachedAdminSession = AdminSessionData.empty;
  }

  Future<void> clearAuth() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kIsLoggedIn);
    await sp.remove(_kUserRole);
    await sp.remove(_kUserId);
    await sp.remove(_kUserName);
    await sp.remove(_kAssignedSpaceIds);
    await sp.remove(_kHasCompletedOnboarding);
    clearAdminSessionCache();
  }
}
