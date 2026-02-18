import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int count;
  final int active;

  const DotIndicator({super.key, required this.count, required this.active});

  /// ✅ دالة: عرض نقاط تحت الصور
  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4E7FB6) : const Color(0xFFE6EEF7),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
