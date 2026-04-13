import 'package:flutter/material.dart';
import '../../../core/di/app_injector.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../../../core/i18n/app_i18n.dart';
import '../widgets/notification_group.dart';
import 'notification_settings_page.dart';
import '../domain/entities/notification_item.dart';
import '../../bookings/view/bookings_tab_page.dart';
import '../../offers/view/offers_page.dart';
import '../../booking_request/view/booking_request_routes.dart';

class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({super.key});

  void _openBookingStatus(BuildContext context, String bookingId) {
    Navigator.of(context).push(
      BookingRequestRoutes.bookingStatus(
        bloc: AppInjector.createBookingBloc(),
        bookingId: bookingId,
      ),
    );
  }

  void _onNotificationTap(BuildContext context, NotificationItem item) {
    switch (item.type) {
      case NotificationType.bookingApproved:
        if (item.bookingId != null) {
          _openBookingStatus(context, item.bookingId!);
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingsTabPage.withBloc()));
        }
        break;
      case NotificationType.bookingRejected:
      case NotificationType.reminder:
        if (item.bookingId != null) {
          _openBookingStatus(context, item.bookingId!);
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingsTabPage.withBloc()));
        }
        break;
      case NotificationType.offerSuggestion:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => OffersPage.withBloc()));
        break;
      case NotificationType.tip:
        break;
    }
  }

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    return BlocProvider(
      create: (_) =>
          AppInjector.createNotificationsBloc()
            ..add(const NotificationsStarted()),
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
        title: Text(
          context.t('notificationsPageTitle'),
          style: const TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  context.t('notificationsPageHeader'),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  context.t('notificationsPageSubtitle'),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                if (state.todayItems.isNotEmpty) ...[
                  NotificationGroup(
                    label: context.t('notifGroupToday'),
                    items: state.todayItems,
                    onItemTap: (item) => _onNotificationTap(context, item),
                  ),
                  const SizedBox(height: 24),
                ],
                if (state.earlierItems.isNotEmpty) ...[
                  NotificationGroup(
                    label: context.t('notifGroupEarlier'),
                    items: state.earlierItems,
                    onItemTap: (item) => _onNotificationTap(context, item),
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
