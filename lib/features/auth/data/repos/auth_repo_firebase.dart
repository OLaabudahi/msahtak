import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/auth_service.dart';
import '../../../../services/local_storage_service.dart';
import '../../domain/repos/auth_repo.dart';
import '../models/user_model.dart';

/// ✅ تنفيذ Firebase لـ AuthRepo
class AuthRepoFirebase implements AuthRepo {
  AuthRepoFirebase(this._storage);

  final LocalStorageService _storage;
  final _service = AuthService();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _service.signIn(email: email, password: password);
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);
      // المستخدم سجّل دخوله = أكمل التسجيل قبل، لا نريه onboarding
      await _storage.setHasCompletedOnboarding(true);
      // حفظ دور المستخدم لتحديد التوجيه (مستخدم عادي أو أدمن)
      await _storage.setUserRole(result['role'] as String? ?? 'user');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data() ?? {};

      return UserModel(
        id: user.uid,
        fullName: data['fullName'] as String? ??
            data['full_name'] as String? ??
            user.displayName ??
            'User',
        email: user.email ?? email,
      );
    }
    throw Exception(result['error'] ?? 'Login failed');
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);
      await _storage.setHasCompletedOnboarding(false);
      return UserModel(id: user.uid, fullName: fullName, email: email);
    }
    throw Exception(result['error'] ?? 'Sign up failed');
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final result = await _service.resetPassword(email);
    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Password reset failed');
    }
  }

  @override
  Future<void> logout() async {
    await _service.signOut();
    await _storage.clearAuth();
  }
}
