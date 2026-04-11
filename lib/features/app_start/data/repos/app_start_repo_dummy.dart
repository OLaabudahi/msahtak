import '../../../../core/utils/role_mapper.dart';
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

    final role = await _storage.getUserRole();
    if (!RoleMapper.isUser(role)) return AppStartDecision.goAdmin;

    final completed = await _storage.getHasCompletedOnboarding();
    if (!completed) return AppStartDecision.goOnboarding;

    return AppStartDecision.goHome;
  }
}
