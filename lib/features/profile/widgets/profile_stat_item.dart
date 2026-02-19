import 'package:flutter/material.dart';

class ProfileStatItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStatItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF5A623),
          ),
        ),
      ],
    );
  }
}
