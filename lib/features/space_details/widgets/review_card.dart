import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../data/models/space_details_model.dart';

class ReviewCard extends StatelessWidget {
  final SpaceReview review;
  const ReviewCard({super.key, required this.review});

  /// âœ… ط¯ط§ظ„ط©: ظƒط§ط±ط¯ ظ…ط±ط§ط¬ط¹ط© طµط؛ظٹط± (Latest reviews)
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.userName,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            review.timeAgo,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${review.stars}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: AppColors.amber),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.25),
          ),
        ],
      ),
    );
  }
}


