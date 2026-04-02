import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

class ChipToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ChipToggle({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AdminColors.primaryBlue.withOpacity(0.15) : Colors.transparent;
    final br = selected ? AdminColors.primaryBlue.withOpacity(0.15) : AdminColors.black15;
    final fg = selected ? AdminColors.primaryBlue : AdminColors.black75;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: br, width: 1),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: fg, w: FontWeight.w600)),
      ),
    );
  }
}


