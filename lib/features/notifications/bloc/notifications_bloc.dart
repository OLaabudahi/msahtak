import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/notification_item.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/get_notification_settings_usecase.dart';
import '../domain/usecases/save_notification_settings_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  final SaveNotificationSettingsUseCase saveNotificationSettingsUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.getNotificationSettingsUseCase,
    required this.saveNotificationSettingsUseCase,
  }) : super(const NotificationsState()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationSettingsStarted>(_onSettingsStarted);
    on<NotificationSettingToggled>(_onSettingToggled);
    on<NotificationReminderTimingChanged>(_onReminderTimingChanged);
    on<NotificationSettingsSaved>(_onSettingsSaved);
  }

  /// طھط­ظ…ظٹظ„ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ ط£ظˆظ„ط§ظ‹ ط«ظ… ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ظ…ط¹ طھطµظپظٹط© ط­ط³ط¨ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ
  Future<void> _onStarted(
      NotificationsStarted event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(isLoadingList: true));
    try {
      final settings = await getNotificationSettingsUseCase();
      final all = await getNotificationsUseCase();

      final filtered = all.where((n) {
        switch (n.type) {
          case NotificationType.bookingApproved:
            return settings.bookingApproved;
          case NotificationType.bookingRejected:
            return settings.bookingRejected;
          case NotificationType.reminder:
            return settings.bookingReminder;
          case NotificationType.offerSuggestion:
            return settings.offerSuggestion;
          case NotificationType.tip:
            return true;
        }
      }).toList();

      final today = filtered.where((n) => !n.isRead).toList();
      final earlier = filtered.where((n) => n.isRead).toList();
      emit(state.copyWith(
          settings: settings,
          todayItems: today,
          earlierItems: earlier,
          isLoadingList: false));
    } catch (e) {
      emit(state.copyWith(isLoadingList: false, error: e.toString()));
    }
  }

  /// طھط­ظ…ظٹظ„ ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ط­ط§ظ„ظٹط©
  Future<void> _onSettingsStarted(NotificationSettingsStarted event,
      Emitter<NotificationsState> emit) async {
    emit(state.copyWith(isLoadingSettings: true));
    try {
      final settings = await getNotificationSettingsUseCase();
      emit(state.copyWith(settings: settings, isLoadingSettings: false));
    } catch (e) {
      emit(state.copyWith(isLoadingSettings: false, error: e.toString()));
    }
  }

  /// طھط¨ط¯ظٹظ„ ظ‚ظٹظ…ط© ط¥ط¹ط¯ط§ط¯ ظ…ط¹ظٹظ†
  void _onSettingToggled(
      NotificationSettingToggled event, Emitter<NotificationsState> emit) {
    final s = state.settings;
    final updated = switch (event.field) {
      'bookingApproved' => s.copyWith(bookingApproved: event.value),
      'bookingRejected' => s.copyWith(bookingRejected: event.value),
      'bookingReminder' => s.copyWith(bookingReminder: event.value),
      'offerSuggestion' => s.copyWith(offerSuggestion: event.value),
      _ => s,
    };
    emit(state.copyWith(settings: updated, isSaved: false));
  }

  /// طھط­ط¯ظٹط« طھظˆظ‚ظٹطھ ط§ظ„طھط°ظƒظٹط±
  void _onReminderTimingChanged(NotificationReminderTimingChanged event,
      Emitter<NotificationsState> emit) {
    emit(state.copyWith(
        settings: state.settings.copyWith(reminderTiming: event.index),
        isSaved: false));
  }

  /// ط­ظپط¸ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ ط¹ط¨ط± ط§ظ„ظ€ use case
  Future<void> _onSettingsSaved(
      NotificationSettingsSaved event, Emitter<NotificationsState> emit) async {
    try {
      await saveNotificationSettingsUseCase(state.settings);
      emit(state.copyWith(isSaved: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}


