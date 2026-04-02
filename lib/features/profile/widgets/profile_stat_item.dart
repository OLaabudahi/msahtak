import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ProfileStatItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStatItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.amber,
          ),
        ),
      ],
    );
  }
}
