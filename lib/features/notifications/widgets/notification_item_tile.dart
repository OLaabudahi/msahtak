import 'package:flutter/material.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/notification_item.dart';

class NotificationItemTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;
  const NotificationItemTile({super.key, required this.item, this.onTap});

  String _translatedTitle(BuildContext context) {
    switch (item.type) {
      case NotificationType.bookingApproved:
        return context.t('notifItemTitleApproved');
      case NotificationType.bookingRejected:
        return context.t('notifItemTitleRejected');
      case NotificationType.reminder:
        return context.t('notifItemTitleReminder');
      case NotificationType.offerSuggestion:
        return context.t('notifItemTitleOffer');
      case NotificationType.tip:
        return item.title;
    }
  }

  String _translatedSubtitle(BuildContext context) {
    switch (item.type) {
      case NotificationType.bookingApproved:
        return context.t('notifItemSubApproved');
      case NotificationType.bookingRejected:
        return context.t('notifItemSubRejected');
      case NotificationType.reminder:
        return context.t('notifItemSubReminder');
      case NotificationType.offerSuggestion:
        return context.t('notifItemSubOffer');
      case NotificationType.tip:
        return item.subtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showAI = item.type == NotificationType.offerSuggestion;
    final hasInnerCircle = item.type == NotificationType.bookingApproved ||
        item.type == NotificationType.bookingRejected ||
        item.type == NotificationType.tip;
    final titleColor =
        item.isRead ? Colors.black : AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
        children: [
          _buildIcon(showAI, hasInnerCircle),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translatedTitle(context),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor),
                ),
                const SizedBox(height: 3),
                Text(_translatedSubtitle(context),
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF5A623)),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildIcon(bool showAI, bool hasInnerCircle) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: _bgColor, borderRadius: BorderRadius.circular(12)),
      child: showAI
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_iconData, color: _iconColor, size: 18),
                const Text('AI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold)),
              ],
            )
          : hasInnerCircle
              ? Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: _innerCircleColor,
                        shape: BoxShape.circle),
                    child: Icon(_iconData, color: _innerIconColor, size: 16),
                  ),
                )
              : Icon(_iconData, color: _iconColor, size: 30),
    );
  }

  IconData get _iconData {
    switch (item.type) {
      case NotificationType.bookingApproved:
        return Icons.check;
      case NotificationType.bookingRejected:
        return Icons.close;
      case NotificationType.reminder:
        return Icons.notifications_outlined;
      case NotificationType.offerSuggestion:
        return Icons.auto_awesome;
      case NotificationType.tip:
        return Icons.info_outline;
    }
  }

  Color get _bgColor {
    switch (item.type) {
      case NotificationType.bookingApproved:
        return AppColors.borderLight;
      case NotificationType.bookingRejected:
        return AppColors.secondaryTint8;
      case NotificationType.reminder:
        return AppColors.borderLight;
      case NotificationType.offerSuggestion:
        return AppColors.planCardBg;
      case NotificationType.tip:
        return AppColors.secondaryTint8;
    }
  }

  Color get _iconColor {
    switch (item.type) {
      case NotificationType.offerSuggestion:
        return AppColors.amber;
      case NotificationType.bookingRejected:
        return AppColors.danger;
      case NotificationType.tip:
        return AppColors.amber;
      default:
        return Colors.black;
    }
  }

  Color get _innerCircleColor {
    switch (item.type) {
      case NotificationType.bookingRejected:
        return AppColors.danger;
      case NotificationType.tip:
        return AppColors.amber;
      default:
        return Colors.black;
    }
  }

  Color get _innerIconColor {
    switch (item.type) {
      case NotificationType.bookingApproved:
        return AppColors.amber;
      default:
        return Colors.white;
    }
  }
}
