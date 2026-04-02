import 'package:equatable/equatable.dart';


class SettingsModel extends Equatable {
  final bool notificationsEnabled;
  final bool bookingRemindersEnabled;
  final String reminderTiming; 

  final String languageCode; 
  final bool darkMode; 

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

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  @override
  List<Object?> get props => [
    notificationsEnabled,
    bookingRemindersEnabled,
    reminderTiming,
    languageCode,
    darkMode,
  ];
}
