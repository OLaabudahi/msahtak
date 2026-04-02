import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class QuickReplyChips extends StatelessWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;

  const QuickReplyChips({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        return InkWell(
          onTap: () => onSelected(o),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              o,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

