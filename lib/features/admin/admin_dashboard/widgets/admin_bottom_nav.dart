import 'package:flutter/material.dart';

import 'admin_colors.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.apartment_outlined, label: 'Spaces'),
      _NavItem(icon: Icons.calendar_today_outlined, label: 'Bookings'),
      _NavItem(icon: Icons.people_outline_rounded, label: 'Users'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Analytics'),
    ];

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AdminColors.borderBlack15, width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          final color = active ? AdminColors.primaryBlue : Colors.black;
          final fw = active ? FontWeight.w600 : FontWeight.w400;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[i].icon, size: 24, color: color),
                    const SizedBox(height: 4),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: fw,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
