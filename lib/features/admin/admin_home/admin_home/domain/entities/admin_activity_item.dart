import 'package:equatable/equatable.dart';

class AdminActivityItem extends Equatable {
  final String userName;
  final String spaceName;
  final String status; // e.g. 'pending', 'approved_waiting_payment', 'confirmed'
  final DateTime createdAt;

  const AdminActivityItem({
    required this.userName,
    required this.spaceName,
    required this.status,
    required this.createdAt,
  });

  /// نص الحدث المعروض
  String get actionText {
    return switch (status) {
      'pending' => 'requested $spaceName',
      'approved_waiting_payment' || 'approved' => 'booking approved for $spaceName',
      'payment_under_review' => 'submitted payment for $spaceName',
      'confirmed' => 'confirmed booking at $spaceName',
      'canceled' || 'rejected' || 'expired' => 'booking cancelled at $spaceName',
      _ => 'booked $spaceName',
    };
  }

  /// وقت منذ الإنشاء
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  List<Object?> get props => [userName, spaceName, status, createdAt];
}
