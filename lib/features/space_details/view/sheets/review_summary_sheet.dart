import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../data/models/space_details_model.dart';

class ReviewSummarySheet extends StatelessWidget {
  final ReviewSummary summary;
  const ReviewSummarySheet({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: Text(
                'Review Summary',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 6),
            
            Center(
              child: Text(
                summary.meta,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),

            
            const Text(
              'Top positives',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.topPositives
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('â€¢ $t',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            
            const Text(
              'Repeated negatives',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.red),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.repeatedNegatives
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('â€¢ $t',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            
            const Text(
              'Crowd & environment',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            const SizedBox(height: 10),
            _CrowdRow(label: 'Crowd level', value: summary.crowdLevel),
            const SizedBox(height: 6),
            _CrowdRow(label: 'Noise', value: summary.noise),

            const SizedBox(height: 24),

            
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrowdRow extends StatelessWidget {
  final String label;
  final String value;
  const _CrowdRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
