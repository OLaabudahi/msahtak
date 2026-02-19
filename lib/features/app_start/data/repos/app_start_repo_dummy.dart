import '../../../../services/local_storage_service.dart';
import '../../domain/repos/app_start_repo.dart';

class AppStartRepoDummy implements AppStartRepo {
  AppStartRepoDummy(this._storage);

  final LocalStorageService _storage;

  @override
  Future<AppStartDecision> decide() async {
    // Simulate a splash delay
    await Future.delayed(const Duration(milliseconds: 900));

    final isLoggedIn = await _storage.getIsLoggedIn();
    if (!isLoggedIn) return AppStartDecision.goLogin;

    final completed = await _storage.getHasCompletedOnboarding();
    if (!completed) return AppStartDecision.goOnboarding;

    return AppStartDecision.goHome;

    // API-ready example (commented):
    // final res = await dio.get('/me');
    // final isLoggedIn = res.statusCode == 200;
    // ...
  }
}
