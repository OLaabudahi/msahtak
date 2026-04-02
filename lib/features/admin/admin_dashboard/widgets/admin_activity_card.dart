import 'package:flutter/material.dart';

class AdminActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeText;

  const AdminActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.15)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.75)),
                ),
              ),
              Text(
                timeText,
                style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}