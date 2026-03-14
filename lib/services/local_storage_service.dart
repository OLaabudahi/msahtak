import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kIsLoggedIn = 'is_logged_in';
  static const _kHasCompletedOnboarding = 'has_completed_onboarding';
  static const _kLocaleCode = 'locale_code';

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

  Future<String?> getUserRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('user_role');
  }

  Future<void> setUserRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('user_role', role);
  }

  Future<void> clearAuth() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kIsLoggedIn);
    await sp.remove('user_role');
  }
}
