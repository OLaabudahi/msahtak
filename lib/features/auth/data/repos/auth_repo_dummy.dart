import 'dart:math';

import '../../../../services/local_storage_service.dart';
import '../models/user_model.dart';
import '../../domain/repos/auth_repo.dart';

class AuthRepoDummy implements AuthRepo {
  AuthRepoDummy(this._storage);

  final LocalStorageService _storage;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!_isValidEmail(email) || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    await _storage.setIsLoggedIn(true);

    return UserModel(
      id: Random().nextInt(999999).toString(),
      fullName: 'Mashtak User',
      email: email.trim(),
    );

    // API-ready example (commented):
    // final res = await dio.post('/auth/login', data: {...});
    // return UserModel.fromJson(res.data['user']);
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1100));

    if (fullName.trim().length < 3) throw Exception('Full name is too short');
    if (!_isValidEmail(email)) throw Exception('Invalid email');
    if (password.length < 6)
      throw Exception('Password must be at least 6 chars');

    await _storage.setIsLoggedIn(true);
    await _storage.setHasCompletedOnboarding(false);

    return UserModel(
      id: Random().nextInt(999999).toString(),
      fullName: fullName.trim(),
      email: email.trim(),
    );

    // API-ready example (commented):
    // final res = await dio.post('/auth/register', data: {...});
    // return UserModel.fromJson(res.data['user']);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 850));
    if (!_isValidEmail(email)) throw Exception('Invalid email');

    // API-ready example (commented):
    // await dio.post('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 350));
    await _storage.clearAuth();

    // API-ready example (commented):
    // await dio.post('/auth/logout');
  }

  bool _isValidEmail(String v) {
    final s = v.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
  }
}


