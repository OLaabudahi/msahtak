import '../../data/models/settings_model.dart';

abstract class SettingsRepo {
  /// âœ… ط¯ط§ظ„ط©: طھط­ظ…ظٹظ„ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ
  Future<SettingsModel> fetchSettings();

  /// âœ… ط¯ط§ظ„ط©: ط­ظپط¸ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ (ظˆظ‚طھ API / Local storage)
  Future<void> saveSettings(SettingsModel settings);
}


