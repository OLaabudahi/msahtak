import 'package:equatable/equatable.dart';

class AdminNotificationItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  final bool isRead;
  final String? bookingId;

  const AdminNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.isRead,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [id, title, subtitle, createdAt, isRead, bookingId];
}
