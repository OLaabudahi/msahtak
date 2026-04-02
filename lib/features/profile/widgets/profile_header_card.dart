import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

import '../data/models/user_model.dart';
import 'profile_stat_item.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserModel user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatarAsset = user.avatarAsset;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.amber,
                        width: 3,
                      ),
                      color: AppColors.borderMedium,
                    ),
                    child: ClipOval(
                      child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? Image.network(
                              user.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.grey,
                              ),
                            )
                          : avatarAsset != null
                              ? Image.asset(avatarAsset, fit: BoxFit.cover)
                              : const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileStatItem(
                      title: 'Bookings',
                      value: user.totalBookings.toString(),
                    ),
                    ProfileStatItem(
                      title: 'Reviews',
                      value: user.completedBookings.toString(),
                    ),
                    ProfileStatItem(
                      title: 'Saved',
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
              color: Colors.black,
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
