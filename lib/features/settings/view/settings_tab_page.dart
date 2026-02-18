import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_start/bloc/app_start_bloc.dart';
import '../../app_start/bloc/app_start_event.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

import '../../../constants/app_spacing.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/language_bottom_sheet.dart';
import '../widgets/settings_action_tile.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_switch_tile.dart';

class SettingsTabPage extends StatelessWidget {
  const SettingsTabPage({super.key});

  /// ✅ فتح الصفحة مع BLoC
  static Widget withBloc() {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(const SettingsStarted()),
      child: const SettingsTabPage(),
    );
  }

  /// ✅ فتح BottomSheet اللغة
  void _openLanguageSheet(BuildContext context, String selected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return LanguageBottomSheet(
          selected: selected,
          onSelect: (code) => context.read<SettingsBloc>().add(SettingsSelectLanguage(code)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        // ✅ لما ينجح logout
        if (state.status == AuthStatus.loggedOut) {
          // ارجعي لأول Route (الروت)
          Navigator.of(context).popUntil((route) => route.isFirst);

          // خلي AppRoot يعيد القرار ويظهر Login
          context.read<AppStartBloc>().add(const AppStartStarted());
        }

        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final bloc = context.read<SettingsBloc>();

          return SafeArea(
            child: Padding(
              padding: AppSpacing.screen.copyWith(top: 10),
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? Center(child: Text('Error: ${state.error}'))
                  : RefreshIndicator(
                onRefresh: () async => bloc.add(const SettingsRefreshRequested()),
                child: ListView(
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    AppSpacing.vMd,
                    const SettingsSectionTitle(text: 'Notifications'),
                    SettingsSwitchTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      subtitle: 'Enable or disable all notifications',
                      value: state.settings!.notificationsEnabled,
                      onChanged: (v) => bloc.add(SettingsToggleNotifications(v)),
                    ),
                    SettingsSwitchTile(
                      icon: Icons.alarm_rounded,
                      title: 'Booking reminders',
                      subtitle: 'Get a reminder before your booking',
                      value: state.settings!.bookingRemindersEnabled,
                      onChanged: (v) => bloc.add(SettingsToggleBookingReminders(v)),
                    ),
                    const SettingsSectionTitle(text: 'Preferences'),
                    SettingsActionTile(
                      icon: Icons.timer_outlined,
                      title: 'Reminder timing',
                      subtitle: state.settings!.reminderTiming,
                      onTap: () {
                        const options = ['30 min', '1 hour', 'Same day (9 AM)'];
                        final current = state.settings!.reminderTiming;
                        final idx = options.indexOf(current);
                        final next = options[(idx + 1) % options.length];
                        bloc.add(SettingsSelectReminderTiming(next));
                      },
                      trailing: const Icon(Icons.swap_horiz_rounded),
                    ),
                    SettingsActionTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: state.settings!.languageCode == 'ar' ? 'Arabic' : 'English',
                      onTap: () => _openLanguageSheet(context, state.settings!.languageCode),
                    ),
                    SettingsSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark mode',
                      subtitle: 'Enable dark theme',
                      value: state.settings!.darkMode,
                      onChanged: (v) => bloc.add(SettingsToggleDarkMode(v)),
                    ),
                    const SettingsSectionTitle(text: 'Account'),
                    SettingsActionTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    SettingsActionTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {},
                    ),

                    // ✅ Logout
                    SettingsActionTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () {
                        context.read<AuthBloc>().add(const AuthLogoutRequested());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
