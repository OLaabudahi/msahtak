import '../../domain/entities/notification_item.dart';
import '../models/notification_item_model.dart';
import '../models/notification_settings_model.dart';


abstract class NotificationsRemoteSource {
  Future<List<NotificationItemModel>> getNotifications();
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettingsModel settings);
}

class FakeNotificationsSource implements NotificationsRemoteSource {
  
  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      
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

  
  @override
  Future<void> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
