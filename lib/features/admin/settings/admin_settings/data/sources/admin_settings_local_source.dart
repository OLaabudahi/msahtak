import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../services/local_storage_service.dart';
import 'admin_settings_source.dart';

class AdminSettingsLocalSource implements AdminSettingsSource {
  final LocalStorageService storage;
  const AdminSettingsLocalSource(this.storage);

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await storage.clearAuth();
  }
}


