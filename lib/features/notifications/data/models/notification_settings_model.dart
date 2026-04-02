import '../../domain/entities/notification_settings.dart';

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    super.bookingApproved = true,
    super.bookingRejected = true,
    super.bookingReminder = false,
    super.offerSuggestion = true,
    super.reminderTiming = 0,
  });

  /// تحويل JSON إلى Model
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      bookingApproved: json['bookingApproved'] as bool? ?? true,
      bookingRejected: json['bookingRejected'] as bool? ?? true,
      bookingReminder: json['bookingReminder'] as bool? ?? false,
      offerSuggestion: json['offerSuggestion'] as bool? ?? true,
      reminderTiming: json['reminderTiming'] as int? ?? 0,
    );
  }

  /// تحويل Model إلى JSON
  Map<String, dynamic> toJson() => {
        'bookingApproved': bookingApproved,
        'bookingRejected': bookingRejected,
        'bookingReminder': bookingReminder,
        'offerSuggestion': offerSuggestion,
        'reminderTiming': reminderTiming,
      };
}
