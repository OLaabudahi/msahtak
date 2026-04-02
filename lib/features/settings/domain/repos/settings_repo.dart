import '../../data/models/settings_model.dart';

abstract class SettingsRepo {
  /// ✅ دالة: تحميل الإعدادات
  Future<SettingsModel> fetchSettings();

  /// ✅ دالة: حفظ الإعدادات (وقت API / Local storage)
  Future<void> saveSettings(SettingsModel settings);
}
