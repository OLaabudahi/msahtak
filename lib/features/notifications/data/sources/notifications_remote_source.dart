import '../../domain/entities/notification_item.dart';
import '../models/notification_item_model.dart';
import '../models/notification_settings_model.dart';

/// ظˆط§ط¬ظ‡ط© ظ…طµط¯ط± ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ FakeNotificationsSource ط¨ظ€ RealNotificationsSource ط¹ظ†ط¯ ط±ط¨ط· API
abstract class NotificationsRemoteSource {
  Future<List<NotificationItemModel>> getNotifications();
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettingsModel settings);
}

class FakeNotificationsSource implements NotificationsRemoteSource {
  /// ط¬ظ„ط¨ ط¨ظٹط§ظ†ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„طھط¬ط±ظٹط¨ظٹط© â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get() ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      // --- TODAY (isRead: false) ---
      NotificationItemModel(
        id: '1',
        title: 'Booking approved',
        subtitle: 'Downtown Hub confirmed your request.',
        time: '2m',
        type: NotificationType.bookingApproved,
        isRead: false,
      ),
      NotificationItemModel(
        id: '2',
        title: 'Reminder before booking',
        subtitle: 'Your session starts in 30 minutes.',
        time: '45m',
        type: NotificationType.reminder,
        isRead: false,
      ),
      NotificationItemModel(
        id: '3',
        title: 'Offer / plan suggestion',
        subtitle: 'Weekly plan could save you 18% for this space.',
        time: '1h',
        type: NotificationType.offerSuggestion,
        isRead: false,
      ),
      // --- EARLIER (isRead: true) ---
      NotificationItemModel(
        id: '4',
        title: 'Booking rejected',
        subtitle: "City Study Room couldn't confirm your time.",
        time: 'Yesterday',
        type: NotificationType.bookingRejected,
        isRead: true,
      ),
      NotificationItemModel(
        id: '5',
        title: 'Tip',
        subtitle: 'You can track all requests in the Bookings tab.',
        time: '2d',
        type: NotificationType.tip,
        isRead: true,
      ),
    ];
  }

  /// ط¬ظ„ط¨ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„طھط¬ط±ظٹط¨ظٹط© â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get() ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const NotificationSettingsModel(
      bookingApproved: true,
      bookingRejected: true,
      bookingReminder: false,
      offerSuggestion: true,
      reminderTiming: 0,
    );
  }

  /// ط­ظپط¸ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.post() ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<void> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: POST /api/notification-settings body: settings.toJson()
  }
}


