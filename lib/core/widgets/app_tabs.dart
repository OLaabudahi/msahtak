import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.scrollable = true,
    this.height = 44,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool scrollable;
  final double height;

  @override
  Widget build(BuildContext context) {
    final children = List.generate(labels.length, (i) {
      final active = i == selectedIndex;
      return ChoiceChip(
        label: Text(labels[i]),
        selected: active,
        onSelected: (_) => onChanged(i),
        selectedColor: AppColors.amber,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: active ? Colors.black : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: active ? AppColors.amber : AppColors.inputBorder,
          ),
        ),
      );
    });

    if (scrollable) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: children.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => children[i],
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Row(
        children: List.generate(children.length, (i) {
          return Expanded(child: Padding(
            padding: EdgeInsetsDirectional.only(end: i == children.length - 1 ? 0 : 8),
            child: children[i],
          ));
        }),
      ),
    );
  }
}
