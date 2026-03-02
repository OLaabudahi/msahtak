import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

import '../../../admin_home/admin_home/view/admin_home_page.dart';
import '../../../bookings/booking_requests/view/booking_requests_page.dart';
import '../../../users/users/view/users_page.dart';
import '../../../settings/admin_settings/view/admin_settings_page.dart';

class AdminRootPage extends StatefulWidget {
  const AdminRootPage({super.key});

  static Widget withBloc() {
    return const AdminRootPage();
  }

  @override
  State<AdminRootPage> createState() => _AdminRootPageState();
}

class _AdminRootPageState extends State<AdminRootPage> {
  int _index = 0;

  final _tabs = const [
    _TabConfig('Home', 0),
    _TabConfig('Bookings', 1),
    _TabConfig('Users', 2),
    _TabConfig('Settings', 3),
  ];

  @override
  Widget build(BuildContext context) {
    final page = switch (_index) {
      0 => AdminHomePage.withBloc(),
      1 => BookingRequestsPage.withBloc(),
      2 => UsersPage.withBloc(),
      _ => AdminSettingsPage.withBloc(),
    };

    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(top: true, bottom: false, child: page),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AdminColors.bg,
            border: Border(top: BorderSide(color: AdminColors.black15, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: _tabs.map((t) {
              final active = t.index == _index;
              final icon = switch (t.index) {
                0 => AdminIconMapper.home(),
                1 => AdminIconMapper.bookings(),
                2 => AdminIconMapper.users(),
                _ => AdminIconMapper.settings(),
              };

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
}

class _TabConfig {
  final String label;
  final int index;
  const _TabConfig(this.label, this.index);
}
