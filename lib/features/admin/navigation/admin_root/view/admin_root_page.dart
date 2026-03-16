import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../../../_shared/admin_session.dart';
import '../../../../../core/i18n/app_i18n.dart';

import '../../../admin_home/admin_home/view/admin_home_page.dart';
import '../../../bookings/booking_requests/view/booking_requests_page.dart';
import '../../../users/users/view/users_page.dart';
import '../../../settings/admin_settings/view/admin_settings_page.dart';
import '../../../sub_admins/view/sub_admins_page.dart';

class AdminRootPage extends StatefulWidget {
  const AdminRootPage({super.key});

  static Widget withBloc() => const AdminRootPage();

  @override
  State<AdminRootPage> createState() => _AdminRootPageState();
}

class _AdminRootPageState extends State<AdminRootPage> {
  int _index = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AdminSession.load();
    if (mounted) setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: AdminColors.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isSuperAdmin = AdminSession.isSuperAdmin;

    // تاب الأدمن الفرعي: Home, Bookings, Settings (بدون Users)
    // تاب الأدمن الكامل: Home, Bookings, Users, Sub Admins, Settings
    final tabs = isSuperAdmin
        ? [
            _TabConfig(context.t('adminTabHome'), 0),
            _TabConfig(context.t('adminTabBookings'), 1),
            _TabConfig(context.t('adminTabUsers'), 2),
            _TabConfig(context.t('adminTabSubAdmins'), 3),
            _TabConfig(context.t('adminTabSettings'), 4),
          ]
        : [
            _TabConfig(context.t('adminTabHome'), 0),
            _TabConfig(context.t('adminTabBookings'), 1),
            _TabConfig(context.t('adminTabSettings'), 2),
          ];

    final pages = isSuperAdmin
        ? [
            AdminHomePage.withBloc(),
            BookingRequestsPage.withBloc(),
            UsersPage.withBloc(),
            SubAdminsPage.withBloc(),
            AdminSettingsPage.withBloc(),
          ]
        : [
            AdminHomePage.withBloc(),
            BookingRequestsPage.withBloc(),
            AdminSettingsPage.withBloc(),
          ];

    final clampedIndex = _index.clamp(0, tabs.length - 1);

    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: IndexedStack(index: clampedIndex, children: pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AdminColors.bg,
            border: Border(top: BorderSide(color: AdminColors.black15, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: tabs.map((t) {
              final active = t.index == clampedIndex;
              final icon = _iconFor(t.index, isSuperAdmin);

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _index = t.index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 20, color: active ? AdminColors.primaryBlue : AdminColors.black40),
                        const SizedBox(height: 6),
                        Text(
                          t.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AdminText.label12(
                            color: active ? AdminColors.primaryBlue : AdminColors.black40,
                            w: active ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(int index, bool isSuperAdmin) {
    if (!isSuperAdmin) {
      return switch (index) {
        0 => AdminIconMapper.home(),
        1 => AdminIconMapper.bookings(),
        _ => AdminIconMapper.settings(),
      };
    }
    return switch (index) {
      0 => AdminIconMapper.home(),
      1 => AdminIconMapper.bookings(),
      2 => AdminIconMapper.users(),
      3 => Icons.admin_panel_settings_outlined,
      _ => AdminIconMapper.settings(),
    };
  }
}

class _TabConfig {
  final String label;
  final int index;
  const _TabConfig(this.label, this.index);
}
