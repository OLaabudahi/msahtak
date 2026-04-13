import 'package:flutter/material.dart';
import '../../../core/widgets/app_tabs.dart';

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
    return AppTabs(
      labels: tabs,
      selectedIndex: index,
      onChanged: onChanged,
      scrollable: false,
    );
  }
}
