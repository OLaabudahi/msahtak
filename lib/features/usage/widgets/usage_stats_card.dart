import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/usage_stats.dart';

class UsageStatsCard extends StatelessWidget {
  final UsageStats stats;

  const UsageStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(
          title: 'Your usage',
          lines: [
            '${stats.totalBookings} bookings • ${stats.totalHours} hours'
                ' • avg ${stats.avgHoursPerSession}h/session',
            'Most common time: ${stats.mostCommonTime}',
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Insights',
          lines: stats.insights.map((i) => '• $i').toList(),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoCard({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(l,
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              )),
        ],
      ),
    );
  }
}


