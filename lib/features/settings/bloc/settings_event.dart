import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsRefreshRequested extends SettingsEvent {
  const SettingsRefreshRequested();
}

class SettingsToggleNotifications extends SettingsEvent {
  final bool value;
  const SettingsToggleNotifications(this.value);
  @override
  List<Object?> get props => [value];
}

class SettingsToggleBookingReminders extends SettingsEvent {
  final bool value;
  const SettingsToggleBookingReminders(this.value);
  @override
  List<Object?> get props => [value];
}

class SettingsSelectReminderTiming extends SettingsEvent {
  final String timing;
  const SettingsSelectReminderTiming(this.timing);
  @override
  List<Object?> get props => [timing];
}

class SettingsSelectLanguage extends SettingsEvent {
  final String languageCode; // "en" / "ar"
  const SettingsSelectLanguage(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class SettingsToggleDarkMode extends SettingsEvent {
  final bool value;
  const SettingsToggleDarkMode(this.value);
  @override
  List<Object?> get props => [value];
}
