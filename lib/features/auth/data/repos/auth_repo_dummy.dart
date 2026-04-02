import 'dart:math';

import 'package:Msahtak/features/auth/data/models/auth_user_model.dart';
import 'package:Msahtak/features/auth/domain/entities/auth_user.dart';

import '../../../../services/local_storage_service.dart';
import '../../domain/repos/auth_repo.dart';

class AuthRepoDummy implements AuthRepo {
  AuthRepoDummy(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!_isValidEmail(email) || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    await _storage.setIsLoggedIn(true);

    return AuthUserModel(
      id: Random().nextInt(999999).toString(),
      fullName: 'Mashtak User',
      email: email.trim(),
      role: 'admin',
      assignedSpaceIds: [],

    );

    
    
    
  }

  @override
  Future<AuthUserModel> signUp({
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

    return AuthUserModel(
      id: Random().nextInt(999999).toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      role: 'user', assignedSpaceIds: [],
    );

    
    
    
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 850));
    if (!_isValidEmail(email)) throw Exception('Invalid email');

    
    
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 350));
    await _storage.clearAuth();

    
    
  }

  bool _isValidEmail(String v) {
    final s = v.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
  }

  @override
  Future<AuthUserModel> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}


