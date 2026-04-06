import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';


class AppStartRepoFirebase implements AppStartRepo {
  AppStartRepoFirebase(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    await Future.delayed(const Duration(milliseconds: 600));


    final user = FirebaseAuth.instance.currentUser ??
        await FirebaseAuth.instance.authStateChanges().first;
    final isLoggedIn = await _storage.getIsLoggedIn();
    if (user == null) {
      return AppStartDecision.goLogin;
    }
    _storage.setUserId(user.uid);
    _storage.setUserName(user.displayName.toString());
    print('[AppStart] decide: user=${user.uid}');

    if (!isLoggedIn) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    ('[AppStart] decide: completed=$completed');
    if (!completed) return AppStartDecision.goOnboarding;

    // إذا كان المستخدم أدمن يُوجَّه لواجهة الإدارة
    final role = (await _storage.getUserRole())?.toLowerCase() ?? '';
    print('[AppStart] decide: role=$role → decision=${role.contains('admin') ? 'goAdmin' : 'goHome'}');
    if (role.contains('admin')) return AppStartDecision.goAdmin;

    return AppStartDecision.goHome;
  }
}
