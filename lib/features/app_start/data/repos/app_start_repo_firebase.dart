import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

/// âœ… طھظ†ظپظٹط° Firebase ظ„ظ€ AppStartRepo â€“ ظٹط¹طھظ…ط¯ ط¹ظ„ظ‰ FirebaseAuth ط¨ط¯ظ„ SharedPreferences
class AppStartRepoFirebase implements AppStartRepo {
  AppStartRepoFirebase(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    await Future.delayed(const Duration(milliseconds: 600));

    // ظ†ط³طھط®ط¯ظ… currentUser ط£ظˆظ„ط§ظ‹طŒ ظˆط¥ظ† ظ„ظ… ظٹطھظˆظپط± ظ†ظ†طھط¸ط± ط£ظˆظ„ ط¥طµط¯ط§ط± ظ…ظ† authStateChanges
    final user = FirebaseAuth.instance.currentUser ??
        await FirebaseAuth.instance.authStateChanges().first;

    debugPrint('[AppStart] decide: user=${user?.uid}');

    if (user == null) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    debugPrint('[AppStart] decide: completed=$completed');
    if (!completed) return AppStartDecision.goOnboarding;

    // ط¥ط°ط§ ظƒط§ظ† ط§ظ„ظ…ط³طھط®ط¯ظ… ط£ط¯ظ…ظ† ظٹظڈظˆط¬ظژظ‘ظ‡ ظ„ظˆط§ط¬ظ‡ط© ط§ظ„ط¥ط¯ط§ط±ط©
    final role = (await _storage.getUserRole())?.toLowerCase() ?? '';
    debugPrint('[AppStart] decide: role=$role â†’ decision=${role.contains('admin') ? 'goAdmin' : 'goHome'}');
    if (role.contains('admin')) return AppStartDecision.goAdmin;

    return AppStartDecision.goHome;
  }
}


