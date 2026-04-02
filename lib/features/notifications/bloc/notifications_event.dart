import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}


class NotificationsStarted extends NotificationsEvent {
  const NotificationsStarted();
}


class NotificationSettingsStarted extends NotificationsEvent {
  const NotificationSettingsStarted();
}


class NotificationSettingToggled extends NotificationsEvent {
  
  final String field;
  final bool value;
  const NotificationSettingToggled(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}


class NotificationReminderTimingChanged extends NotificationsEvent {
  final int index;
  const NotificationReminderTimingChanged(this.index);
  @override
  List<Object?> get props => [index];
}


class NotificationSettingsSaved extends NotificationsEvent {
  const NotificationSettingsSaved();
}
