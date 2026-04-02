import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsActionTile extends StatelessWidget {
  final IconData? icon; 
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;
  final bool isLast;

  const SettingsActionTile({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isDestructive = false,
    this.isLast = false,
  });

  static const _chevronBlue = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.danger : Colors.black;
    final subColor = AppColors.textSecondary;

    final defaultTrailing = Icon(
      Icons.chevron_right,
      color: isDestructive ? AppColors.danger : _chevronBlue,
      size: 22,
    );

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: titleColor),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: subColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing ?? defaultTrailing,
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: Colors.white.withOpacity(0.7),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
