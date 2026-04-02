import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  static const _kIsLoggedIn = 'is_logged_in';
  static const _kHasCompletedOnboarding = 'has_completed_onboarding';
  static const _kLocaleCode = 'locale_code';

  static const _kUserId = 'user_id';
  static const _kUserName = 'user_name';
  static const _kUserRole = 'user_role';
  static const _kAssignedSpaceIds = 'assigned_space_ids';

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

  /// USER ID
  Future<String?> getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserId);
  }

  Future<void> setUserId(String id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserId, id);
  }

  /// USER NAME
  Future<String?> getUserName() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserName);
  }

  Future<void> setUserName(String name) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserName, name);
  }

  /// USER ROLE
  Future<String?> getUserRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUserRole);
  }

  Future<void> setUserRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserRole, role);
  }

  /// SPACES
  Future<List<String>> getAssignedSpaceIds() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kAssignedSpaceIds) ?? [];
  }

  Future<void> setAssignedSpaceIds(List<String> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kAssignedSpaceIds, ids);
  }

  Future<void> clearAuth() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kIsLoggedIn);
    await sp.remove(_kUserRole);
    await sp.remove(_kUserId);
    await sp.remove(_kUserName);
    await sp.remove(_kAssignedSpaceIds);
  }
}

