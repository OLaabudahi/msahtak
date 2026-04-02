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

  /// ظ…ظپطھط§ط­ طھط±ط¬ظ…ط© ط§ظ„ظپط¹ظ„ â€” ظٹظڈط³طھط®ط¯ظ… ظپظٹ ط§ظ„ظ€ widget ظ…ط¹ context.t()
  String get actionKey {
    return switch (status) {
      'pending' => 'activityRequested',
      'approved_waiting_payment' || 'approved' => 'activityApproved',
      'payment_under_review' => 'activityPayment',
      'confirmed' => 'activityConfirmed',
      'canceled' || 'rejected' || 'expired' => 'activityCancelled',
      _ => 'activityBooked',
    };
  }

  /// ظ…ط¯ط© ظ…ظ†ط° ط§ظ„ط¥ظ†ط´ط§ط، â€” (key, n) ظ„ظٹطھط±ط¬ظ…ظ‡ط§ ط§ظ„ظ€ widget
  ({String key, int n}) get timeAgoData {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return (key: 'timeJustNow', n: 0);
    if (diff.inMinutes < 60) return (key: 'timeMinAgo', n: diff.inMinutes);
    if (diff.inHours < 24) return (key: 'timeHoursAgo', n: diff.inHours);
    return (key: 'timeDaysAgo', n: diff.inDays);
  }

  @override
  List<Object?> get props => [userName, spaceName, status, createdAt];
}


