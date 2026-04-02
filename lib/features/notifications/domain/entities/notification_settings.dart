import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  final bool bookingApproved;
  final bool bookingRejected;
  final bool bookingReminder;
  final bool offerSuggestion;

  
  final int reminderTiming;

  const NotificationSettings({
    this.bookingApproved = true,
    this.bookingRejected = true,
    this.bookingReminder = false,
    this.offerSuggestion = true,
    this.reminderTiming = 0,
  });

  NotificationSettings copyWith({
    bool? bookingApproved,
    bool? bookingRejected,
    bool? bookingReminder,
    bool? offerSuggestion,
    int? reminderTiming,
  }) {
    return NotificationSettings(
      bookingApproved: bookingApproved ?? this.bookingApproved,
      bookingRejected: bookingRejected ?? this.bookingRejected,
      bookingReminder: bookingReminder ?? this.bookingReminder,
      offerSuggestion: offerSuggestion ?? this.offerSuggestion,
      reminderTiming: reminderTiming ?? this.reminderTiming,
    );
  }

  @override
  List<Object?> get props => [
        bookingApproved,
        bookingRejected,
        bookingReminder,
        offerSuggestion,
        reminderTiming,
      ];
}
