import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  /// ✅ دالة: عنصر قائمة للبروفايل (Edit/Profile/Logout...)
  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFDC2626) : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, color: color),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.subtext.withOpacity(.8)),
            ],
          ),
        ),
      ),
    );
  }
}