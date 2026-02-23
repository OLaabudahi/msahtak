import 'package:equatable/equatable.dart';

enum NotificationType {
  bookingApproved,
  bookingRejected,
  reminder,
  offerSuggestion,
  tip,
}

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, subtitle, time, type, isRead];
}
