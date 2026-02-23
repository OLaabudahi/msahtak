import 'package:equatable/equatable.dart';
import '../domain/entities/notification_item.dart';
import '../domain/entities/notification_settings.dart';

class NotificationsState extends Equatable {
  final List<NotificationItem> todayItems;
  final List<NotificationItem> earlierItems;
  final NotificationSettings settings;
  final bool isLoadingList;
  final bool isLoadingSettings;
  final bool isSaved;
  final String? error;

  const NotificationsState({
    this.todayItems = const [],
    this.earlierItems = const [],
    this.settings = const NotificationSettings(),
    this.isLoadingList = false,
    this.isLoadingSettings = false,
    this.isSaved = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationItem>? todayItems,
    List<NotificationItem>? earlierItems,
    NotificationSettings? settings,
    bool? isLoadingList,
    bool? isLoadingSettings,
    bool? isSaved,
    String? error,
  }) {
    return NotificationsState(
      todayItems: todayItems ?? this.todayItems,
      earlierItems: earlierItems ?? this.earlierItems,
      settings: settings ?? this.settings,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingSettings: isLoadingSettings ?? this.isLoadingSettings,
      isSaved: isSaved ?? this.isSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        todayItems,
        earlierItems,
        settings,
        isLoadingList,
        isLoadingSettings,
        isSaved,
        error,
      ];
}
