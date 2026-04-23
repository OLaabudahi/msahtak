import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/role_mapper.dart';
import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

class AppStartRepoFirebase implements AppStartRepo {
  AppStartRepoFirebase(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    final user = FirebaseAuth.instance.currentUser ??
        await FirebaseAuth.instance.authStateChanges().first;

    if (user == null) {
      return AppStartDecision.goLogin;
    }

    await _storage.setIsLoggedIn(true);
    await _storage.setUserId(user.uid);
    if ((user.displayName ?? '').trim().isNotEmpty) {
      await _storage.setUserName(user.displayName!.trim());
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = userDoc.data() ?? <String, dynamic>{};

    final mappedRole = RoleMapper.map(data['role']?.toString());
    await _storage.setUserRole(mappedRole);

    final rawAssigned = data['assignedSpaceIds'];
    final assigned = rawAssigned is List
        ? rawAssigned.map((e) => e.toString()).toList()
        : <String>[];
    await _storage.setAssignedSpaceIds(assigned);

    final profileName = data['fullName']?.toString().trim();
    if ((profileName ?? '').isNotEmpty) {
      await _storage.setUserName(profileName!);
    }

    final onboardingMap = data['onboarding'];
    final completedFromFirestore = onboardingMap is Map
        ? onboardingMap['completed'] == true
        : false;
    final completedFromLocal = await _storage.getHasCompletedOnboarding();
    final completed = completedFromFirestore || completedFromLocal;
    await _storage.setHasCompletedOnboarding(completed);

    if (!RoleMapper.isUser(mappedRole)) {
      return AppStartDecision.goAdmin;
    }

    if (!completed) {
      return AppStartDecision.goOnboarding;
    }

    return AppStartDecision.goHome;
  }
}
