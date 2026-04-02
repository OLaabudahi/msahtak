import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textMuted)),
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
    );
  }
}


