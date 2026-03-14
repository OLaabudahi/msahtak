import '../../domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.time,
    required super.type,
    super.isRead,
    super.requestId,
  });

  /// تحويل JSON إلى Model
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
      requestId: json['requestId'] as String?,
    );
  }

  /// تحويل Model إلى JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'time': time,
        'type': type.name,
        'isRead': isRead,
        'requestId': requestId,
      };
}
