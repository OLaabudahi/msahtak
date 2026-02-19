import 'package:flutter/material.dart';

import '../../../domain/entities/booking_request_entity.dart';

class BookingRequestSummaryCard extends StatelessWidget {
  final BookingRequestEntity request;

  const BookingRequestSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
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
          Text(request.space.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          _RowLine(label: 'Request ID', value: request.requestId),
          const SizedBox(height: 8),
          _RowLine(label: 'Start', value: _fmtDate(request.startDate)),
          const SizedBox(height: 8),
          _RowLine(label: 'Duration', value: '${request.durationValue} ${request.durationUnit.name}'),
          const SizedBox(height: 8),
          _RowLine(label: 'Purpose', value: request.purposeLabel ?? '—'),
          const SizedBox(height: 8),
          _RowLine(label: 'Offer', value: request.offerLabel ?? '—'),
          const SizedBox(height: 10),
          const Divider(height: 18),
          _RowLine(label: 'Total', value: '₪${request.totalAmount}', bold: true),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

class _RowLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _RowLine({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500);
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(color: Colors.grey[700]))),
        Text(value, style: style),
      ],
    );
  }
}

