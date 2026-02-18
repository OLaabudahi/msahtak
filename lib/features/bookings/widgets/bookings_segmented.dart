import 'package:flutter/material.dart';

class BookingsSegmented extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const BookingsSegmented({
    super.key,
    required this.index,
    required this.onChanged,
  });

  /// ✅ دالة: Segmented لأقسام الحجوزات
  @override
  Widget build(BuildContext context) {
    const tabs = ['Upcoming', 'Past'];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEF7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == index;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFF8B324) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                    color: selected ? Colors.black : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
