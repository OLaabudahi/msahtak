import 'package:flutter/material.dart';

import 'admin_colors.dart';

class AdminQuickActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AdminQuickActionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AdminColors.borderBlack15, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }
}


