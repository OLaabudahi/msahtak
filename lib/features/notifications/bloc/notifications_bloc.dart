import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/notification_item.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/get_notification_settings_usecase.dart';
import '../domain/usecases/get_fcm_token_usecase.dart';
import '../domain/usecases/listen_notifications_usecase.dart';
import '../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../domain/usecases/save_notification_settings_usecase.dart';
import '../domain/usecases/save_fcm_token_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  final SaveNotificationSettingsUseCase saveNotificationSettingsUseCase;
  final GetFcmTokenUseCase getFcmTokenUseCase;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;
  final ListenNotificationsUseCase listenNotificationsUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  StreamSubscription<Map<String, dynamic>>? _notificationsSubscription;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.getNotificationSettingsUseCase,
    required this.saveNotificationSettingsUseCase,
    required this.getFcmTokenUseCase,
    required this.saveFcmTokenUseCase,
    required this.listenNotificationsUseCase,
    required this.markAllNotificationsReadUseCase,
  }) : super(const NotificationsState()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationSettingsStarted>(_onSettingsStarted);
    on<NotificationSettingToggled>(_onSettingToggled);
    on<NotificationReminderTimingChanged>(_onReminderTimingChanged);
    on<NotificationSettingsSaved>(_onSettingsSaved);

    _notificationsSubscription = listenNotificationsUseCase().listen((_) {
      add(const NotificationsStarted());
    });
  }

  /// تحميل الإعدادات أولاً ثم الإشعارات مع تصفية حسب الإعدادات
  Future<void> _onStarted(
      NotificationsStarted event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(isLoadingList: true));
    try {
      final token = await getFcmTokenUseCase();
      if (token != null && token.isNotEmpty) {
        await saveFcmTokenUseCase(token);
      }

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

      await markAllNotificationsReadUseCase();
      final markedRead = filtered.map((n) => NotificationItem(id: n.id, title: n.title, subtitle: n.subtitle, time: n.time, type: n.type, isRead: true, bookingId: n.bookingId)).toList();
      final today = markedRead.where((n) => !n.isRead).toList();
      final earlier = markedRead.where((n) => n.isRead).toList();
      emit(state.copyWith(
          settings: settings,
          todayItems: today,
          earlierItems: earlier,
          isLoadingList: false));
    } catch (e) {
      emit(state.copyWith(isLoadingList: false, error: e.toString()));
    }
  }

  /// تحميل إعدادات الإشعارات الحالية
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

  /// تبديل قيمة إعداد معين
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

  /// تحديث توقيت التذكير
  void _onReminderTimingChanged(NotificationReminderTimingChanged event,
      Emitter<NotificationsState> emit) {
    emit(state.copyWith(
        settings: state.settings.copyWith(reminderTiming: event.index),
        isSaved: false));
  }

  /// حفظ الإعدادات عبر الـ use case
  Future<void> _onSettingsSaved(
      NotificationSettingsSaved event, Emitter<NotificationsState> emit) async {
    try {
      await saveNotificationSettingsUseCase(state.settings);
      emit(state.copyWith(isSaved: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _notificationsSubscription?.cancel();
    return super.close();
  }
}
