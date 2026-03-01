import 'dart:math';
import '../../../../services/local_storage_service.dart';
import '../models/user_model.dart';
import 'auth_source.dart';

class AuthDummySource implements AuthSource {
  AuthDummySource(this._storage);

  final LocalStorageService _storage;

  bool _isValidEmail(String email) => email.contains('@') && email.contains('.');

  String _roleFromEmail(String email) {
    final e = email.trim().toLowerCase();
    return e.contains('admin') ? 'admin' : 'user';
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!_isValidEmail(email) || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    await _storage.setIsLoggedIn(true);

    return UserModel(
      id: Random().nextInt(999999).toString(),
      fullName: 'Mashtak User',
      email: email.trim(),
      role: _roleFromEmail(email),
    );
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (fullName.trim().isEmpty || !_isValidEmail(email) || password.length < 6) {
      throw Exception('Invalid signup data');
    }

    await _storage.setIsLoggedIn(true);

    return UserModel(
      id: Random().nextInt(999999).toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      role: _roleFromEmail(email),
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!_isValidEmail(email)) throw Exception('Invalid email');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _storage.setIsLoggedIn(false);
  }
}