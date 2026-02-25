import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل قائمة الإشعارات
class NotificationsStarted extends NotificationsEvent {
  const NotificationsStarted();
}

/// تحميل إعدادات الإشعارات
class NotificationSettingsStarted extends NotificationsEvent {
  const NotificationSettingsStarted();
}

/// تغيير قيمة إعداد معين
class NotificationSettingToggled extends NotificationsEvent {
  // field: 'bookingApproved' | 'bookingRejected' | 'bookingReminder' | 'offerSuggestion'
  final String field;
  final bool value;
  const NotificationSettingToggled(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

/// تغيير توقيت التذكير (0=30min, 1=1hour, 2=same day)
class NotificationReminderTimingChanged extends NotificationsEvent {
  final int index;
  const NotificationReminderTimingChanged(this.index);
  @override
  List<Object?> get props => [index];
}

/// حفظ الإعدادات
class NotificationSettingsSaved extends NotificationsEvent {
  const NotificationSettingsSaved();
}
