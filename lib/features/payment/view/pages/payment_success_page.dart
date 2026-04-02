import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../../theme/app_colors.dart';

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
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE083)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_top, color: Color(0xFFB8860B), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Submitted', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Awaiting admin confirmation. You will be notified.', style: TextStyle(fontSize: 12, color: Color(0xFF7A5A00))),
                        ],
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
                    // ظ„ظˆ ط¨ط¯ظƒ: ط§ظپطھط­ظٹ Booking Details ط¨ط§ظ„ظ€ bookingId
                    // Navigator.pushNamed(context, '/booking-details', arguments: args.bookingId);
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
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
        border: Border.all(color: AppColors.inputBorder),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Details', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _row('Booking ID', bookingId),
          const SizedBox(height: 8),
          _row('Amount paid', 'â‚ھ$amountPaid'),
          const SizedBox(height: 8),
          _row('Paid at', paid),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 52,
            margin: const EdgeInsets.only(top: 10),
            child: OutlinedButton.icon(
              onPressed: () => _downloadInvoice(bookingId: bookingId, amountPaid: amountPaid, paidAt: paidAt),
              icon: const Icon(Icons.download),
              label: const Text('Download Invoice (PDF)'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                side: const BorderSide(color: AppColors.inputBorder),
              ),
            ),
          ),

        ],
      ),
    );
  }

  static Future<void> _downloadInvoice({
    required String bookingId,
    required int amountPaid,
    required DateTime paidAt,
  }) async {
    final pdf = pw.Document();
    final fmtDate = _fmtDateTime(paidAt);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('INVOICE', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Divider(),
          pw.SizedBox(height: 16),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Booking ID:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(bookingId),
          ]),
          pw.SizedBox(height: 8),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Amount Paid:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('ILS $amountPaid'),
          ]),
          pw.SizedBox(height: 8),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Date:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(fmtDate),
          ]),
          pw.SizedBox(height: 24),
          pw.Divider(),
          pw.SizedBox(height: 8),
          pw.Text('Status: Payment Under Review', style: pw.TextStyle(color: PdfColors.orange700)),
          pw.SizedBox(height: 4),
          pw.Text('This invoice will be confirmed once the admin verifies your payment.', style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    ));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Widget _row(String k, String v) {
    return Row(
      children: [
        Expanded(child: Text(k, style: TextStyle(color: AppColors.textDark))),
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



