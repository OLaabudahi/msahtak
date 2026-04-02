import 'package:flutter/material.dart';

import 'admin_colors.dart';

class AdminActivityTile extends StatelessWidget {
  final String user;
  final String action;
  final String space;
  final String time;

  const AdminActivityTile({
    super.key,
    required this.user,
    required this.action,
    required this.space,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AdminColors.borderBlack15, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ' ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AdminColors.black75,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AdminColors.black40,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }
}


