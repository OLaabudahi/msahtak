import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_spacing.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_stat_item.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileStarted()),
      child: const ProfileTabPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final bloc = context.read<ProfileBloc>();

        return SafeArea(
          child: Padding(
            padding: AppSpacing.screen,
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('Error: ${state.error}'))
                : RefreshIndicator(
              onRefresh: () async =>
                  bloc.add(const ProfileRefreshRequested()),
              child: ListView(
                children: [
                  ProfileHeaderCard(user: state.user!),
                  AppSpacing.vLg,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileStatItem(
                        title: 'Total',
                        value:
                        state.user!.totalBookings.toString(),
                      ),
                      ProfileStatItem(
                        title: 'Completed',
                        value:
                        state.user!.completedBookings.toString(),
                      ),
                      ProfileStatItem(
                        title: 'Saved',
                        value:
                        state.user!.savedSpaces.toString(),
                      ),
                    ],
                  ),

                  AppSpacing.vLg,

                  ProfileMenuTile(
                    title: 'Edit Profile',
                    icon: Icons.person_outline,
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    title: 'Payment Methods',
                    icon: Icons.credit_card_outlined,
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    title: 'Help Center',
                    icon: Icons.help_outline,
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    title: 'Logout',
                    icon: Icons.logout,
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
