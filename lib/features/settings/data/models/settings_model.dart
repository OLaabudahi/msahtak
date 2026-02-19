import 'package:equatable/equatable.dart';

/// ✅ موديل الإعدادات (Dummy الآن - API-ready)
class SettingsModel extends Equatable {
  final bool notificationsEnabled;
  final bool bookingRemindersEnabled;
  final String reminderTiming; // "30 min" / "1 hour" / "Same day (9 AM)"

  final String languageCode; // "en" / "ar"
  final bool darkMode; // (لو بدك تربطيه لاحقاً بالThemeBloc)

  const SettingsModel({
    required this.notificationsEnabled,
    required this.bookingRemindersEnabled,
    required this.reminderTiming,
    required this.languageCode,
    required this.darkMode,
  });

  SettingsModel copyWith({
    bool? notificationsEnabled,
    bool? bookingRemindersEnabled,
    String? reminderTiming,
    String? languageCode,
    bool? darkMode,
  }) {
    return SettingsModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      bookingRemindersEnabled:
          bookingRemindersEnabled ?? this.bookingRemindersEnabled,
      reminderTiming: reminderTiming ?? this.reminderTiming,
      languageCode: languageCode ?? this.languageCode,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  /// ✅ API READY (كومنت)
  // factory SettingsModel.fromJson(Map<String, dynamic> json) {
  //   return SettingsModel(
  //     notificationsEnabled: json['notificationsEnabled'] ?? true,
  //     bookingRemindersEnabled: json['bookingRemindersEnabled'] ?? true,
  //     reminderTiming: json['reminderTiming'] ?? '30 min',
  //     languageCode: json['languageCode'] ?? 'en',
  //     darkMode: json['darkMode'] ?? false,
  //   );
  // }
  //
  // Map<String, dynamic> toJson() => {
  //   'notificationsEnabled': notificationsEnabled,
  //   'bookingRemindersEnabled': bookingRemindersEnabled,
  //   'reminderTiming': reminderTiming,
  //   'languageCode': languageCode,
  //   'darkMode': darkMode,
  // };

  @override
  List<Object?> get props => [
    notificationsEnabled,
    bookingRemindersEnabled,
    reminderTiming,
    languageCode,
    darkMode,
  ];
}
