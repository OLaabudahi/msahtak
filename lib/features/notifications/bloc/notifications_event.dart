import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ظ‚ط§ط¦ظ…ط© ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ
class NotificationsStarted extends NotificationsEvent {
  const NotificationsStarted();
}

/// طھط­ظ…ظٹظ„ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ
class NotificationSettingsStarted extends NotificationsEvent {
  const NotificationSettingsStarted();
}

/// طھط؛ظٹظٹط± ظ‚ظٹظ…ط© ط¥ط¹ط¯ط§ط¯ ظ…ط¹ظٹظ†
class NotificationSettingToggled extends NotificationsEvent {
  // field: 'bookingApproved' | 'bookingRejected' | 'bookingReminder' | 'offerSuggestion'
  final String field;
  final bool value;
  const NotificationSettingToggled(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

/// طھط؛ظٹظٹط± طھظˆظ‚ظٹطھ ط§ظ„طھط°ظƒظٹط± (0=30min, 1=1hour, 2=same day)
class NotificationReminderTimingChanged extends NotificationsEvent {
  final int index;
  const NotificationReminderTimingChanged(this.index);
  @override
  List<Object?> get props => [index];
}

/// ط­ظپط¸ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ
class NotificationSettingsSaved extends NotificationsEvent {
  const NotificationSettingsSaved();
}


