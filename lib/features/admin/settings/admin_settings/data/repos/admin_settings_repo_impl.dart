import '../../domain/repos/admin_settings_repo.dart';
import '../sources/admin_settings_source.dart';

class AdminSettingsRepoImpl implements AdminSettingsRepo {
  final AdminSettingsSource source;
  const AdminSettingsRepoImpl(this.source);

  @override
  Future<void> logout() => source.logout();
}
