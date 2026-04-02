import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class RatingBarRow extends StatelessWidget {
  final int stars;
  final int count;
  final int total;

  const RatingBarRow({
    super.key,
    required this.stars,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;
    final gradientColors = _gradientFor(stars);

    return Row(
      children: [
        SizedBox(
          width: 14,
          child: Text('$stars',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 14,
          child: Text('$count',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  List<Color> _gradientFor(int stars) {
    switch (stars) {
      case 5:
        return [
          AppColors.amber,
          AppColors.secondary
        ];
      case 4:
        return [
          AppColors.amber,
          AppColors.ratingGreen
        ];
      default:
        return [
          AppColors.secondary,
          AppColors.secondary
        ];
    }
  }
}


