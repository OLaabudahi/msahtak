import 'package:Msahtak/features/profile/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_assets.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import 'profile_stat_item.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Image.asset(AppAssets.logo, width: 25)
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileStatItem(
                      title: context.t('bookingsCount'),
                      value: user.totalBookings.toString(),
                    ),
                    ProfileStatItem(
                      title: context.t('reviewsCount'),
                      value: user.completedBookings.toString(),
                    ),
                    ProfileStatItem(
                      title: context.t('savedSpacesCount'),
                      value: user.savedSpaces.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user.email,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 1),
          if (user.phoneNumber != null) ...[
            const SizedBox(height: 1),
            Text(
              user.phoneNumber!,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
