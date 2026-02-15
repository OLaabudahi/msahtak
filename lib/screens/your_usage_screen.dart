import 'package:flutter/material.dart';

class YourUsageScreen extends StatefulWidget {
  const YourUsageScreen({Key? key}) : super(key: key);

  @override
  State<YourUsageScreen> createState() => _YourUsageScreenState();
}

class _YourUsageScreenState extends State<YourUsageScreen> {
  int _selectedPlan = 1; // 0=Daily, 1=Weekly, 2=Monthly (default Weekly)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Your Usage',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 38),
                  child: Text(
                    'Based on your last 30 days',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                // Your usage card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your usage',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '8 bookings • 22 hours • avg 2.7h/session',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Most common time: 6–10 PM',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Insights card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insights',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• You often book in the evening.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• You prefer places within 2 km.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Plan Optimizer
                const Text(
                  'Plan Optimizer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Compare plans',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // Plans comparison
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      // Daily
                      _buildPlanItem(
                        index: 0,
                        name: 'Daily',
                        price: '\$10/day',
                        isBest: false,
                      ),
                      // Weekly - Best
                      _buildPlanItem(
                        index: 1,
                        name: 'Weekly',
                        price: '\$58/week',
                        isBest: true,
                      ),
                      // Monthly
                      _buildPlanItem(
                        index: 2,
                        name: 'Monthly',
                        price: '\$199/month',
                        isBest: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Recommendation card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendation',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Weekly saves you ~22% vs Daily based on your usage.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Apply Weekly Plan button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply Weekly Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanItem({
    required int index,
    required String name,
    required String price,
    required bool isBest,
  }) {
    final isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        margin: isSelected
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF5B8FB9).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.black87, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(name, style: const TextStyle(fontSize: 14, color: Colors.black)),
            ),
            Text(price, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            if (isBest) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Best',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
