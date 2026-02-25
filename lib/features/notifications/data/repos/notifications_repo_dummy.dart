import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repos/notifications_repo.dart';
import '../models/notification_settings_model.dart';
import '../sources/notifications_remote_source.dart';

class NotificationsRepoDummy implements NotificationsRepo {
  final NotificationsRemoteSource source;
  NotificationsRepoDummy(this.source);

  /// جلب الإشعارات من المصدر وتحويلها إلى entities
  @override
  Future<List<NotificationItem>> getNotifications() =>
      source.getNotifications();

  /// جلب إعدادات الإشعارات وتحويلها إلى entity
  @override
  Future<NotificationSettings> getNotificationSettings() =>
      source.getNotificationSettings();

  /// حفظ الإعدادات عبر تحويل entity إلى model
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
