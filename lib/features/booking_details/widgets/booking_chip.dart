import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class BookingChip extends StatelessWidget {
  final String text;
  const BookingChip({super.key, required this.text});

  /// âœ… ط¯ط§ظ„ط©: Chip طµط؛ظٹط± ظ„ظ„ظ…ط¹ظ„ظˆظ…ط§طھ (Quiet / Fast Wi-Fi ...)
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}


