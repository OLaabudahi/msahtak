import 'package:flutter/material.dart';

import '../../../domain/entities/payment_summary_entity.dart';

class PaymentBookingSummaryCard extends StatelessWidget {
  final PaymentSummaryEntity? summary;

  const PaymentBookingSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final s = summary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (s == null)
            Text('—', style: TextStyle(color: Colors.grey[700]))
          else ...[
            ...s.items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(child: Text(i.label, style: TextStyle(color: Colors.grey[800]))),
                  Text('₪${i.amount}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            )),

            const Divider(height: 18),
            Row(
              children: [
                const Expanded(child: Text('Total', style: TextStyle(fontWeight: FontWeight.w800))),
                Text('₪${s.total}', style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

