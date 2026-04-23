import 'package:flutter/material.dart';

import '../../../../../core/i18n/app_i18n.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/admin_notification_item.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({
    super.key,
    required this.items,
    required this.onOpenBooking,
  });

  final List<AdminNotificationItem> items;
  final ValueChanged<String> onOpenBooking;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = items.where((e) {
      final d = e.createdAt;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();
    final earlier = items.where((e) => !today.contains(e)).toList();

    return Scaffold(
      backgroundColor: AdminColors.bg,
      appBar: AppBar(
        backgroundColor: AdminColors.bg,
        title: Text(context.t('notificationsPageTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          if (today.isNotEmpty) ...[
            Text(context.t('notifGroupToday'), style: AdminText.label12(w: FontWeight.w700)),
            const SizedBox(height: 8),
            ...today.map((item) => _NotificationCard(item: item, onOpenBooking: onOpenBooking)),
            const SizedBox(height: 16),
          ],
          if (earlier.isNotEmpty) ...[
            Text(context.t('notifGroupEarlier'), style: AdminText.label12(w: FontWeight.w700)),
            const SizedBox(height: 8),
            ...earlier.map((item) => _NotificationCard(item: item, onOpenBooking: onOpenBooking)),
          ],
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(context.t('adminNoRecentActivity'), style: AdminText.body14()),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onOpenBooking,
  });

  final AdminNotificationItem item;
  final ValueChanged<String> onOpenBooking;

  @override
  Widget build(BuildContext context) {
    final bookingId = item.bookingId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: bookingId == null || bookingId.isEmpty ? null : () => onOpenBooking(bookingId),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AdminColors.black10),
          ),
          child: Row(
            children: [
              Icon(
                item.isRead ? Icons.notifications_none : Icons.notifications_active_outlined,
                color: AdminColors.primaryBlue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: AdminText.body14(w: FontWeight.w700)),
                    if (item.subtitle.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.subtitle, style: AdminText.body14(color: AdminColors.black40)),
                    ],
                  ],
                ),
              ),
              if (bookingId != null && bookingId.isNotEmpty)
                Icon(Icons.chevron_right, color: AdminColors.black40),
            ],
          ),
        ),
      ),
    );
  }
}
