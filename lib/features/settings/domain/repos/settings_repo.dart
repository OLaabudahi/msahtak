import '../../data/models/settings_model.dart';

abstract class SettingsRepo {
  
  Future<SettingsModel> fetchSettings();

  
  Future<void> saveSettings(SettingsModel settings);
}
