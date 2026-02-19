import '../models/settings_model.dart';
import '../../domain/repos/settings_repo.dart';

/// ✅ Dummy repo (جاهز للاستبدال بالـ API أو Local storage)
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

    // ✅ API READY (كومنت)
    // final res = await dio.get('/settings');
    // return SettingsModel.fromJson(res.data);

    // ✅ Local storage READY (كومنت)
    // final json = await storage.read('settings');
    // return SettingsModel.fromJson(json);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cache = settings;

    // ✅ API READY (كومنت)
    // await dio.put('/settings', data: settings.toJson());

    // ✅ Local storage READY (كومنت)
    // await storage.write('settings', settings.toJson());
  }
}
