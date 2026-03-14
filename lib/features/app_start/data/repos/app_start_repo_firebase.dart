import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

/// ✅ تنفيذ Firebase لـ AppStartRepo – يعتمد على FirebaseAuth بدل SharedPreferences
class AppStartRepoFirebase implements AppStartRepo {
  AppStartRepoFirebase(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    await Future.delayed(const Duration(milliseconds: 600));

    // نستخدم currentUser أولاً، وإن لم يتوفر ننتظر أول إصدار من authStateChanges
    final user = FirebaseAuth.instance.currentUser ??
        await FirebaseAuth.instance.authStateChanges().first;
    final isLoggedIn = await _storage.getIsLoggedIn();

    debugPrint('[AppStart] decide: user=${user?.uid}, isLoggedIn=$isLoggedIn');

    if (user == null || !isLoggedIn) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    debugPrint('[AppStart] decide: completed=$completed');
    if (!completed) return AppStartDecision.goOnboarding;

    // إذا كان المستخدم أدمن يُوجَّه لواجهة الإدارة
    final role = (await _storage.getUserRole())?.toLowerCase() ?? '';
    debugPrint('[AppStart] decide: role=$role → decision=${role.contains('admin') ? 'goAdmin' : 'goHome'}');
    if (role.contains('admin')) return AppStartDecision.goAdmin;

    return AppStartDecision.goHome;
  }
}
