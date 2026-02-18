import 'package:flutter/material.dart';
import '../../data/models/space_details_model.dart';

class ReviewSummarySheet extends StatelessWidget {
  final ReviewSummary summary;
  const ReviewSummarySheet({super.key, required this.summary});

  /// ✅ دالة: BottomSheet لعرض Review Summary
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(summary.header, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
            const SizedBox(height: 10),
            Text(summary.meta, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),

            const Text('Top positives', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.topPositives.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $t', style: const TextStyle(fontWeight: FontWeight.w700)),
                )).toList(),
              ),
            ),

            const SizedBox(height: 14),
            const Text('Repeated negatives', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFFEDED), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.repeatedNegatives.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $t', style: const TextStyle(fontWeight: FontWeight.w700)),
                )).toList(),
              ),
            ),

            const SizedBox(height: 14),
            const Text('Crowd & environment', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF3F6FB), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Crowd level: ${summary.crowdLevel}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Noise: ${summary.noise}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder()),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
