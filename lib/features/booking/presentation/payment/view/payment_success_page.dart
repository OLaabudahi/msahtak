import 'package:flutter/material.dart';

class PaymentSuccessArgs {
  final String bookingId;
  final int amountPaid;
  final String currency;
  final DateTime paidAt;

  const PaymentSuccessArgs({
    required this.bookingId,
    required this.amountPaid,
    required this.currency,
    required this.paidAt,
  });
}

class PaymentSuccessPage extends StatelessWidget {
  final PaymentSuccessArgs args;

  const PaymentSuccessPage({super.key, required this.args});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment done'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: _pagePadding,
          child: Column(
            children: [
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7EE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFE2BE)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Payment successful',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _InfoCard(
                bookingId: args.bookingId,
                amountPaid: args.amountPaid,
                paidAt: args.paidAt,
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // لو بدك: افتحي Booking Details بالـ bookingId
                    // Navigator.pushNamed(context, '/booking-details', arguments: args.bookingId);
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String bookingId;
  final int amountPaid;
  final DateTime paidAt;

  const _InfoCard({
    required this.bookingId,
    required this.amountPaid,
    required this.paidAt,
  });

  @override
  Widget build(BuildContext context) {
    final paid = _fmtDateTime(paidAt);

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
          const Text('Details', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _row('Booking ID', bookingId),
          const SizedBox(height: 8),
          _row('Amount paid', '₪$amountPaid'),
          const SizedBox(height: 8),
          _row('Paid at', paid),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                // API-ready: فتح invoiceUrl عندما يتوفر
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Get invoice'),

            ),

          ),
          Container(
            width: double.infinity,
            height: 52,
            margin: const EdgeInsets.only(top: 10),
            child: OutlinedButton.icon(
              onPressed: () {
                // API-ready: open invoiceUrl when available
              },
              icon: const Icon(Icons.download),
              label: const Text('Download invoice'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                side: const BorderSide(color: Color(0xFFEAEAEA)),
              ),
            ),
          ),

        ],
      ),
    );
  }

  static Widget _row(String k, String v) {
    return Row(
      children: [
        Expanded(child: Text(k, style: TextStyle(color: Colors.grey[700]))),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }

  static String _fmtDateTime(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}  $hh:$mi';
  }
}

