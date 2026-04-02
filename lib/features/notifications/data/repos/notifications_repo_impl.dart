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
}

