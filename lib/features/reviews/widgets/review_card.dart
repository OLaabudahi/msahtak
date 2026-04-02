import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.secondaryTint8,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.spaceName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(review.timeAgo,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < review.stars ? Icons.star : Icons.star_border,
                size: 16,
                color: AppColors.amber,
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(review.text,
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: review.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.borderLight),
                ),
                child: Text(tag,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


