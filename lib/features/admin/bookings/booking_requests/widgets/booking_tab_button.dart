import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

class BookingTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color activeIconColor;
  final bool active;
  final VoidCallback onTap;

  const BookingTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.activeIconColor,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = active ? AdminColors.primaryAmber : AdminColors.black15;
    final bg = active ? AdminColors.primaryAmber.withOpacity(0.15) : Colors.transparent;
    final iconColor = active ? AdminColors.primaryAmber : AdminColors.black40;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minWidth: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              maxLines: 1,
              style: AdminText.body14(
                color: AdminColors.text,
                w: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
