import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isDestructive = false,
  });

  /// ✅ Tile أكشن (لغة / توقيت / Logout)
  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFDC2626) : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w900, color: color)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(subtitle!, style: const TextStyle(color: AppColors.subtext, fontWeight: FontWeight.w600, fontSize: 12.5)),
                  ],
                ],
              ),
            ),
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.subtext.withOpacity(.8)),
          ],
        ),
      ),
    );
  }
}
