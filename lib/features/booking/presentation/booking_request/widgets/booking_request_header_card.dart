import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

import '../../../domain/entities/booking_request_entity.dart';

class BookingRequestHeaderCard extends StatelessWidget {
  final SpaceSummaryEntity space;

  const BookingRequestHeaderCard({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.settingCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(space.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            'Base price: ₪${space.basePricePerDay} / day',
            style: TextStyle(color: AppColors.textDark, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

