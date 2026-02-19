import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_text_styles.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_action_tile.dart';
import '../widgets/settings_section_title.dart';

class SettingsTabPage extends StatelessWidget {
  const SettingsTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(const SettingsStarted()),
      child: const SettingsTabPage(),
    );
  }

  static const _cardBg = Color(0xFFEAF0F6);
  static const _chevronBlue = Color(0xFF5B8FB9);

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        const Text('Settings', style: AppTextStyles.sectionBarTitle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final bloc = context.read<SettingsBloc>();

        if (state.loading) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 14),
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => bloc.add(const SettingsRefreshRequested()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => bloc.add(const SettingsRefreshRequested()),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _header(context),
                const SizedBox(height: 18),

                const SettingsSectionTitle(text: 'Preferences'),
                _card([
                  SettingsActionTile(
                    icon: null,
                    title: 'Workspace preferences',
                    subtitle: 'Study, work, meetings',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: _chevronBlue,
                      size: 22,
                    ),
                    onTap: () {
                      // TODO: open workspace preferences page (feature)
                    },
                  ),
                  SettingsActionTile(
                    icon: null,
                    title: 'Location',
                    subtitle: 'Nearby & map search',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: _chevronBlue,
                      size: 22,
                    ),
                    onTap: () {
                      // TODO: open location settings page (feature)
                    },
                  ),
                  SettingsActionTile(
                    icon: null,
                    title: 'Notifications',
                    subtitle: 'Booking & offers',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: _chevronBlue,
                      size: 22,
                    ),
                    isLast: true,
                    onTap: () {
                      // TODO: open notifications settings page (feature)
                    },
                  ),
                ]),

                const SizedBox(height: 18),

                const SettingsSectionTitle(text: 'Support'),
                _card([
                  SettingsActionTile(
                    icon: null,
                    title: 'Help & support',
                    subtitle: 'FAQs, contact us',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: _chevronBlue,
                      size: 22,
                    ),
                    onTap: () {
                      // TODO: open help & support page (feature)
                    },
                  ),
                  SettingsActionTile(
                    icon: null,
                    title: 'About Mashtak',
                    subtitle: 'Version, terms, privacy',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: _chevronBlue,
                      size: 22,
                    ),
                    isLast: true,
                    onTap: () {
                      // TODO: open about page (feature)
                    },
                  ),
                ]),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
