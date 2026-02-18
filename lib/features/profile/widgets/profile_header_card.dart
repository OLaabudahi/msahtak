import 'package:flutter/material.dart';

import '../../../constants/app_assets.dart';
import '../../../theme/app_colors.dart';
import '../data/models/user_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserModel user;

  const ProfileHeaderCard({super.key, required this.user});

  /// ✅ دالة: بناء هيدر البروفايل (صورة + اسم + ايميل)
  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarAsset ?? AppAssets.home;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EEF7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              avatar,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),

            // ✅ API READY (كومنت)
            // child: user.avatarUrl != null
            //     ? Image.network(user.avatarUrl!, width: 64, height: 64, fit: BoxFit.cover)
            //     : Image.asset(avatar, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          // Name + Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: AppColors.subtext,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),

          // Edit icon (optional)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.edit_outlined, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
