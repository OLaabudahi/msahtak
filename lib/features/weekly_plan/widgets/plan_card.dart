import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PlanCard extends StatelessWidget {
  final int pricePerWeek;

  const PlanCard({super.key, required this.pricePerWeek});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.planCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for you',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Plan',
                    style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Unlimited access for 7 days',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'â‚ھ$pricePerWeek',
                    style: const TextStyle(
                        color: AppColors.amber,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'per week',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
