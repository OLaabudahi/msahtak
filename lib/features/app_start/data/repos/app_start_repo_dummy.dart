import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

class AppStartRepoDummy implements AppStartRepo {
  AppStartRepoDummy(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    await Future.delayed(const Duration(milliseconds: 900));

    final isLoggedIn = await _storage.getIsLoggedIn();
    if (!isLoggedIn) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    if (!completed) return AppStartDecision.goOnboarding;

    // ط¥ط°ط§ ظƒط§ظ† ط§ظ„ظ…ط³طھط®ط¯ظ… ط£ط¯ظ…ظ† ظٹظڈظˆط¬ظژظ‘ظ‡ ظ„ظˆط§ط¬ظ‡ط© ط§ظ„ط¥ط¯ط§ط±ط©
    final role = (await _storage.getUserRole())?.toLowerCase() ?? '';
    if (role.contains('admin')) return AppStartDecision.goAdmin;

    return AppStartDecision.goHome;
  }
}


