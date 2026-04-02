import '../models/settings_model.dart';
import '../../domain/repos/settings_repo.dart';


class SettingsRepoDummy implements SettingsRepo {
  SettingsModel _cache = const SettingsModel(
    notificationsEnabled: true,
    bookingRemindersEnabled: true,
    reminderTiming: '30 min',
    languageCode: 'en',
    darkMode: false,
  );

  @override
  Future<SettingsModel> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _cache;

    
    
    

    
    
    
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cache = settings;

    
    

    
    
  }
}
