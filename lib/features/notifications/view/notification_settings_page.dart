import 'package:flutter/material.dart';
import '../../../core/di/app_injector.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../../../core/i18n/app_i18n.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/timing_chip.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    return BlocProvider(
      create: (_) =>
          AppInjector.createNotificationsBloc()
            ..add(const NotificationSettingsStarted()),
      child: const NotificationSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listenWhen: (p, c) => c.isSaved && !p.isSaved,
          listener: (context, state) => Navigator.pop(context),
          builder: (context, state) {
            if (state.isLoadingSettings) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            final s = state.settings;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.t('notifSettingsTitle'),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.t('notifSettingsStayInControl'),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.t('notifSettingsChooseUpdates'),
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    // Booking Alerts
                    Text(context.t('bookingAlerts'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTint8,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          SettingsToggleTile(
                            title: context.t('bookingApproved'),
                            subtitle: context.t('bookingApprovedSubtitle'),
                            value: s.bookingApproved,
                            onChanged: (v) =>
                                context.read<NotificationsBloc>().add(
                                    NotificationSettingToggled(
                                        'bookingApproved', v)),
                          ),
                          Divider(color: AppColors.borderLight, height: 1),
                          SettingsToggleTile(
                            title: context.t('bookingRejected'),
                            subtitle: context.t('bookingRejectedSubtitle'),
                            value: s.bookingRejected,
                            onChanged: (v) =>
                                context.read<NotificationsBloc>().add(
                                    NotificationSettingToggled(
                                        'bookingRejected', v)),
                          ),
                          Divider(color: AppColors.borderLight, height: 1),
                          SettingsToggleTile(
                            title: context.t('notifSettingsBookingReminder'),
                            subtitle: context.t('notifSettingsReminderSub'),
                            value: s.bookingReminder,
                            onChanged: (v) =>
                                context.read<NotificationsBloc>().add(
                                    NotificationSettingToggled(
                                        'bookingReminder', v)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Reminder Timing
                    Row(
                      children: [
                        Text(context.t('reminderTiming'),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        const SizedBox(width: 8),
                        Text(context.t('optionalLabel'),
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        TimingChip(
                          label: context.t('timing30min'),
                          index: 0,
                          selectedIndex: s.reminderTiming,
                          onTap: () =>
                              context.read<NotificationsBloc>().add(
                                  const NotificationReminderTimingChanged(
                                      0)),
                        ),
                        TimingChip(
                          label: context.t('timing1hour'),
                          index: 1,
                          selectedIndex: s.reminderTiming,
                          onTap: () =>
                              context.read<NotificationsBloc>().add(
                                  const NotificationReminderTimingChanged(
                                      1)),
                        ),
                        TimingChip(
                          label: context.t('timingSameDay'),
                          index: 2,
                          selectedIndex: s.reminderTiming,
                          onTap: () =>
                              context.read<NotificationsBloc>().add(
                                  const NotificationReminderTimingChanged(
                                      2)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Offers & Plans
                    Text(context.t('notifSettingsOffersPlans'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTint8,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SettingsToggleTile(
                        title: context.t('notifSettingsOfferSuggestion'),
                        subtitle: context.t('notifSettingsOfferSub'),
                        value: s.offerSuggestion,
                        onChanged: (v) =>
                            context.read<NotificationsBloc>().add(
                                NotificationSettingToggled(
                                    'offerSuggestion', v)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context
                            .read<NotificationsBloc>()
                            .add(const NotificationSettingsSaved()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(26)),
                          elevation: 0,
                        ),
                        child: Text(context.t('save'),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
