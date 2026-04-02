import 'package:Msahtak/features/auth/data/models/auth_user_model.dart';
import 'package:Msahtak/features/auth/domain/entities/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/role_mapper.dart';
import '../../../../services/local_storage_service.dart';
import '../../domain/repos/auth_repo.dart';
import '../sources/auth_remote_source.dart';

class AuthRepoFirebase implements AuthRepo {
  AuthRepoFirebase(this._storage);

  final LocalStorageService _storage;

  // final _service = AuthService();
  final AuthRemoteSource source = AuthRemoteSource();

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    debugPrint('[Auth] login attempt: $email');
    final result = await source.login(email: email, password: password);
    debugPrint(
      '[Auth] signIn result: success=${result['success']}, role=${result['role']}, error=${result['error']}',
    );
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);

      await _storage.setHasCompletedOnboarding(true);

      /*await _storage.setUserRole(result['role'] as String? ?? 'user');*/
      final rawRole = result['role'] as String?;
      final mappedRole = RoleMapper.map(rawRole);

      await _storage.setUserRole(mappedRole);

      final ids = result['assignedSpaceIds'];
      if (ids is List<String>) await _storage.setAssignedSpaceIds(ids);

      Map<String, dynamic> data = {};
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        data = doc.data() ?? {};
      } catch (e) {
        debugPrint('[Auth] Firestore profile read failed (non-fatal): $e');
      }

      return AuthUserModel(
        id: user.uid,
        fullName: data['fullName'] as String? ?? user.displayName ?? 'User',
        email: user.email ?? email,
        role: data['role'] as String,
        assignedSpaceIds: [],
      );
    }
    throw Exception(result['error'] ?? 'Login failed');
  }

  @override
  Future<AuthUserModel> loginWithGoogle() async {
    final user = await source.loginWithGoogle();
    if (user.id != '') {
      await _storage.setIsLoggedIn(true);
      await _storage.setUserRole('user');

    }
    return  user;
  }

  @override
  Future<AuthUserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await source.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);
      await _storage.setHasCompletedOnboarding(false);
      return AuthUserModel(id: user.uid, fullName: fullName, email: email, role: 'user', assignedSpaceIds: []);
    }
    throw Exception(result['error'] ?? 'Sign up failed');
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final result = await source.resetPassword(email);
    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Password reset failed');
    }
  }

  @override
  Future<void> logout() async {
    await source.logout();
    await _storage.clearAuth();
  }
}
