import '../models/settings_model.dart';
import '../../domain/repos/settings_repo.dart';

/// âœ… Dummy repo (ط¬ط§ظ‡ط² ظ„ظ„ط§ط³طھط¨ط¯ط§ظ„ ط¨ط§ظ„ظ€ API ط£ظˆ Local storage)
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

    // âœ… API READY (ظƒظˆظ…ظ†طھ)
    // final res = await dio.get('/settings');
    // return SettingsModel.fromJson(res.data);

    // âœ… Local storage READY (ظƒظˆظ…ظ†طھ)
    // final json = await storage.read('settings');
    // return SettingsModel.fromJson(json);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cache = settings;

    // âœ… API READY (ظƒظˆظ…ظ†طھ)
    // await dio.put('/settings', data: settings.toJson());

    // âœ… Local storage READY (ظƒظˆظ…ظ†طھ)
    // await storage.write('settings', settings.toJson());
  }
}


