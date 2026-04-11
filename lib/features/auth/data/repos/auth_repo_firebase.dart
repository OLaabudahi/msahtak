import 'package:Msahtak/features/auth/data/models/auth_user_model.dart';
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

    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Login failed');
    }

    final user = result['user'] as User;
    final rawIds = result['assignedSpaceIds'];
    final assignedSpaceIds = rawIds is List
        ? rawIds.map((e) => e.toString()).toList()
        : <String>[];

    final profile = await _syncSessionFromProfile(
      uid: user.uid,
      fallbackName: user.displayName,
      fallbackRole: result['role']?.toString() ?? 'user',
      fallbackAssignedSpaceIds: assignedSpaceIds,
    );

    return AuthUserModel(
      id: user.uid,
      fullName: profile.fullName,
      email: user.email ?? email,
      role: profile.role,
      assignedSpaceIds: profile.assignedSpaceIds,
    );
  }

  @override
  Future<AuthUserModel> loginWithGoogle() async {
    final user = await source.loginWithGoogle();

    if (user.id.isEmpty) {
      throw Exception('Google login failed');
    }

    final profile = await _syncSessionFromProfile(
      uid: user.id,
      fallbackName: user.fullName,
      fallbackRole: user.role,
      fallbackAssignedSpaceIds: user.assignedSpaceIds,
    );

    return AuthUserModel(
      id: user.id,
      fullName: profile.fullName,
      email: user.email,
      role: profile.role,
      assignedSpaceIds: profile.assignedSpaceIds,
    );
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

    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Sign up failed');
    }

    final user = result['user'] as User;
    await _storage.setIsLoggedIn(true);
    await _storage.setUserId(user.uid);
    await _storage.setUserName(fullName);
    await _storage.setUserRole('user');
    await _storage.setAssignedSpaceIds(const <String>[]);
    await _storage.setHasCompletedOnboarding(false);

    return AuthUserModel(
      id: user.uid,
      fullName: fullName,
      email: email,
      role: 'user',
      assignedSpaceIds: const <String>[],
    );
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

  Future<_SessionProfile> _syncSessionFromProfile({
    required String uid,
    required String? fallbackName,
    required String? fallbackRole,
    required List<String> fallbackAssignedSpaceIds,
  }) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() ?? <String, dynamic>{};

    final mappedRole = RoleMapper.map(data['role']?.toString() ?? fallbackRole);
    final rawAssigned = data['assignedSpaceIds'];
    final assignedSpaceIds = rawAssigned is List
        ? rawAssigned.map((e) => e.toString()).toList()
        : fallbackAssignedSpaceIds;

    final fullName =
        (data['fullName']?.toString().trim().isNotEmpty ?? false)
            ? data['fullName'].toString().trim()
            : (fallbackName?.trim().isNotEmpty ?? false)
                ? fallbackName!.trim()
                : 'User';

    final onboardingData = data['onboarding'];
    final completedFromFirestore = onboardingData is Map
        ? onboardingData['completed'] == true
        : false;

    await _storage.setIsLoggedIn(true);
    await _storage.setUserId(uid);
    await _storage.setUserName(fullName);
    await _storage.setUserRole(mappedRole);
    await _storage.setAssignedSpaceIds(assignedSpaceIds);
    await _storage.setHasCompletedOnboarding(completedFromFirestore);

    return _SessionProfile(
      fullName: fullName,
      role: mappedRole,
      assignedSpaceIds: assignedSpaceIds,
    );
  }
}

class _SessionProfile {
  const _SessionProfile({
    required this.fullName,
    required this.role,
    required this.assignedSpaceIds,
  });

  final String fullName;
  final String role;
  final List<String> assignedSpaceIds;
}
