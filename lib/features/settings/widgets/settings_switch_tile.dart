import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// ✅ جديد (اختياري) عشان divider مثل SettingsScreen
  final bool isLast;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  static const _accent = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.switchThumb,
                activeTrackColor: AppColors.switchActiveTrack,
                inactiveThumbColor: AppColors.switchThumb,
                inactiveTrackColor: AppColors.switchInactiveTrack,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: _accent.withOpacity(0.15),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
