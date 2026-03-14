import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/user_entity.dart';

class UserRow extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onView;

  const UserRow({super.key, required this.user, required this.onView});

  @override
  Widget build(BuildContext context) {
    final badge = user.status == UserStatus.blocked
        ? AdminTag(text: 'Blocked', tint: AdminColors.danger.withOpacity(0.15), textColor: AdminColors.danger)
        : AdminTag(text: 'Active', tint: AdminColors.success.withOpacity(0.15), textColor: AdminColors.success);

    return AdminCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AdminColors.primaryBlue, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(user.avatar, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: Colors.white, w: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    badge,
                    if (user.flagged) ...[
                      const SizedBox(width: 8),
                      AdminTag(text: 'Flagged', tint: AdminColors.primaryAmber.withOpacity(0.15), textColor: AdminColors.primaryAmber),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AdminColors.black15, width: 1)),
              child: Row(
                children: [
                  Icon(AdminIconMapper.eye(), size: 16, color: AdminColors.black40),
                  const SizedBox(width: 6),
                  Text('View', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
