import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

/// ✅ تنفيذ Firebase لـ AppStartRepo – يعتمد على FirebaseAuth بدل SharedPreferences
class AppStartRepoFirebase implements AppStartRepo {
  AppStartRepoFirebase(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    if (!completed) return AppStartDecision.goOnboarding;

    // إذا كان المستخدم أدمن يُوجَّه لواجهة الإدارة
    final role = (await _storage.getUserRole())?.toLowerCase() ?? '';
    if (role.contains('admin')) return AppStartDecision.goAdmin;

    return AppStartDecision.goHome;
  }
}
