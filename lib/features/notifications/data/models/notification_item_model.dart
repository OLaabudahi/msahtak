import '../../domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.time,
    required super.type,
    super.isRead,
    super.bookingId,
  });

  /// طھط­ظˆظٹظ„ JSON ط¥ظ„ظ‰ Model
  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      time: json['time'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.tip,
      ),
      isRead: json['isRead'] as bool? ?? false,
      bookingId: json['bookingId'] as String?,
    );
  }

  /// طھط­ظˆظٹظ„ Model ط¥ظ„ظ‰ JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'time': time,
        'type': type.name,
        'isRead': isRead,
        'bookingId': bookingId,
      };
}


