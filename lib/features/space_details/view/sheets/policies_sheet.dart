import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../data/models/space_details_model.dart';

class PoliciesSheet extends StatelessWidget {
  final SpacePolicies policies;
  const PoliciesSheet({super.key, required this.policies});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                policies.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            if (policies.subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Center(
                child: Text(
                  policies.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Sections
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: policies.sections.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: s.bullets
                                  .map((b) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: Text(
                                          '• $b',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Close button
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
