import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

import '../../../domain/entities/booking_price_quote_entity.dart';

class BookingPriceSummaryCard extends StatelessWidget {
  final BookingPriceQuoteEntity? quote;
  final int durationValue;
  final String currency;

  const BookingPriceSummaryCard({
    super.key,
    required this.quote,
    required this.durationValue,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final q = quote;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RowLine(label: 'Space ($durationValue days)', value: q == null ? '—' : '₪${q.spaceSubtotal}'),
          const SizedBox(height: 8),
          _RowLine(label: 'Offer discount', value: q == null ? '—' : '-₪${q.offerDiscount}'),
          const SizedBox(height: 8),
          _RowLine(label: 'Add-ons', value: q == null ? '—' : '₪${q.addOnsTotal}'),
          const Divider(height: 20),
          _RowLine(
            label: 'Total',
            value: q == null ? '—' : '₪${q.total}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _RowLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _RowLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
