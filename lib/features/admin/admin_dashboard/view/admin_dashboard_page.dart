import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard_event.dart';
import '../bloc/admin_dashboard_state.dart';
import '../data/repos/admin_dashboard_repo_dummy.dart';
import '../domain/entities/admin_dashboard_data_entity.dart';
import '../domain/usecases/get_admin_dashboard_data_usecase.dart';
import '../widgets/admin_activity_tile.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_colors.dart';
import '../widgets/admin_quick_action_button.dart';
import '../widgets/admin_space_dropdown.dart';
import '../widgets/admin_stat_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  static Widget withBloc() {
    final repo = AdminDashboardRepoDummy();
    final usecase = GetAdminDashboardDataUseCase(repo);

    return BlocProvider(
      create: (_) => AdminDashboardBloc(usecase)..add(const AdminDashboardStarted()),
      child: const AdminDashboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        final bloc = context.read<AdminDashboardBloc>();
        final data = state.data;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: _Header(),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: AdminSpaceDropdown(
                          selected: data?.selectedSpace ?? 'Downtown Hub',
                          spaces: data?.spaces ?? const ['Downtown Hub'],
                          open: state.dropdownOpen,
                          onToggle: () => bloc.add(const AdminDashboardDropdownToggled()),
                          onSelect: (s) => bloc.add(AdminDashboardSpaceSelected(s)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: _StatsGrid(data: data, status: state.status),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
                            label: const Text('Add New Space', style: TextStyle(fontFamily: 'SF Pro Text')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'Recent Activity',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Column(
                          children: (data?.activities ?? const []).map((a) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AdminActivityTile(user: a.user, action: a.action, space: a.space, time: a.time),
                            );
                          }).toList(),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'Quick Actions',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            AdminQuickActionButton(label: 'View Requests', onTap: () {}),
                            AdminQuickActionButton(label: 'Manage Calendar', onTap: () {}),
                            AdminQuickActionButton(label: 'Create Offer', onTap: () {}),
                            AdminQuickActionButton(label: 'View Reviews', onTap: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: AdminBottomNav(
                    currentIndex: state.navIndex,
                    onChanged: (i) => bloc.add(AdminDashboardNavChanged(i)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Admin Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text')),
        SizedBox(height: 8),
        Text('Manage your coworking spaces', style: TextStyle(color: AdminColors.black40, fontFamily: 'SF Pro Text')),
      ],
    );
  }
}

IconData _mapStatIcon(AdminStatIcon icon) {
  switch (icon) {
    case AdminStatIcon.bookings:
      return Icons.calendar_today_outlined;
    case AdminStatIcon.pending:
      return Icons.access_time_rounded;
    case AdminStatIcon.occupancy:
      return Icons.people_outline_rounded;
    case AdminStatIcon.revenue:
      return Icons.attach_money_rounded;
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminDashboardDataEntity? data;
  final AdminDashboardStatus status;

  const _StatsGrid({required this.data, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == AdminDashboardStatus.loading) {
      return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
    }

    final stats = data?.stats ?? const [];
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: stats.map((s) {
        return AdminStatCard(
          icon: _mapStatIcon(s.icon),
          iconColor: Color(s.colorHex),
          value: s.value,
          label: s.label,
        );
      }).toList(),
    );
  }
}