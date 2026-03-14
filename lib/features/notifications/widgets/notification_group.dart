import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/notification_item.dart';
import 'notification_item_tile.dart';

class NotificationGroup extends StatelessWidget {
  final String label;
  final List<NotificationItem> items;
  final void Function(NotificationItem)? onItemTap;

  const NotificationGroup({
    super.key,
    required this.label,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderDark, width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  NotificationItemTile(item: items[i], onTap: onItemTap != null ? () => onItemTap!(items[i]) : null),
                  if (i < items.length - 1)
                    Divider(
                        color: AppColors.borderLight,
                        height: 1,
                        indent: 16,
                        endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
