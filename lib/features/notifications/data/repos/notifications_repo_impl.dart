import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repos/notifications_repo.dart';
import '../models/notification_settings_model.dart';
import '../sources/notifications_remote_source.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsRemoteSource source;

  NotificationsRepoImpl(this.source);

  @override
  Future<List<NotificationItem>> getNotifications() {
    return source.getNotifications();
  }

  @override
  Future<NotificationSettings> getNotificationSettings() {
    return source.getNotificationSettings();
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) {
    return source.saveNotificationSettings(
      NotificationSettingsModel(
        bookingApproved: settings.bookingApproved,
        bookingRejected: settings.bookingRejected,
        bookingReminder: settings.bookingReminder,
        offerSuggestion: settings.offerSuggestion,
        reminderTiming: settings.reminderTiming,
      ),
    );
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  }) {
    return source.sendNotification(
      userId: userId,
      bookingId: bookingId,
      title: title,
      body: body,
    );
  }

  @override
  Future<String?> getFcmToken() => source.getFcmToken();

  @override
  Future<void> saveFcmToken(String token) => source.saveFcmToken(token);

  @override
  Stream<Map<String, dynamic>> listenNotifications() => source.listenNotifications();

  @override
  Future<void> markAllAsRead() => source.markAllAsRead();
}
