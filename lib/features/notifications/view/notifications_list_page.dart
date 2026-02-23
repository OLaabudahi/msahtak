import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../data/repos/notifications_repo_dummy.dart';
import '../data/sources/notifications_remote_source.dart';
import '../domain/usecases/get_notification_settings_usecase.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/save_notification_settings_usecase.dart';
import '../widgets/notification_group.dart';
import 'notification_settings_page.dart';

class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    final source = FakeNotificationsSource();
    final repo = NotificationsRepoDummy(source);
    return BlocProvider(
      create: (_) => NotificationsBloc(
        getNotificationsUseCase: GetNotificationsUseCase(repo),
        getNotificationSettingsUseCase:
            GetNotificationSettingsUseCase(repo),
        saveNotificationSettingsUseCase:
            SaveNotificationSettingsUseCase(repo),
      )..add(const NotificationsStarted()),
      child: const NotificationsListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NotificationSettingsPage.withBloc(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.isLoadingList) {
            return const Center(
                child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Updates for you',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Booking status, reminders, and smart plan tips.',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                if (state.todayItems.isNotEmpty) ...[
                  NotificationGroup(
                    label: 'TODAY',
                    items: state.todayItems,
                  ),
                  const SizedBox(height: 24),
                ],
                if (state.earlierItems.isNotEmpty) ...[
                  NotificationGroup(
                    label: 'EARLIER',
                    items: state.earlierItems,
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
