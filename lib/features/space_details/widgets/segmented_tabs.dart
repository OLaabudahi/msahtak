import 'package:flutter/material.dart';

class SegmentedTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const SegmentedTabs({
    super.key,
    required this.index,
    required this.onChanged,
  });

  /// ✅ دالة: Tabs بشكل segmented مثل التصميم
  @override
  Widget build(BuildContext context) {
    const tabs = ['Overview', 'Reviews', 'Offers'];

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
                  color: selected
                      ? const Color(0xFFF8B324)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
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
