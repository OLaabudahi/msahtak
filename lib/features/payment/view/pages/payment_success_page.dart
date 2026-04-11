import 'package:Msahtak/constants/app_assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PaymentSuccessPage extends StatefulWidget {
  final PaymentSuccessArgs args;

  const PaymentSuccessPage({super.key, required this.args});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  late final Future<_BookingInvoiceData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadInvoiceData();
  }

  Future<_BookingInvoiceData> _loadInvoiceData() async {
    final db = FirebaseFirestore.instance;
    final bookingDoc = await db.collection('bookings').doc(widget.args.bookingId).get();
    final data = bookingDoc.data() ?? <String, dynamic>{};

    final status = (data['status'] ?? '').toString();
    final amount = (data['totalAmount'] as num?)?.toInt() ??
        (data['totalPrice'] as num?)?.toInt() ??
        widget.args.amountPaid;

    final currency = (data['currency'] ?? widget.args.currency).toString();
    final paymentMethod =
        (data['paymentMethodName'] ?? data['paymentMethod'] ?? '-').toString();
    final spaceName =
        (data['spaceName'] ?? data['workspaceName'] ?? data['space_name'] ?? 'Space').toString();

    final startAt = _toDateTime(data['startDate']);
    final endAt = _toDateTime(data['endDate']);
    final paidAt = _toDateTime(data['paidAt']) ?? widget.args.paidAt;

    final userId = (data['userId'] ?? data['user_id'] ?? '').toString();
    String customerName = (data['userName'] ?? data['guestName'] ?? 'Customer').toString();
    String customerEmail = '-';
    if (userId.isNotEmpty) {
      final userDoc = await db.collection('users').doc(userId).get();
      final u = userDoc.data() ?? <String, dynamic>{};
      customerName = (u['name'] ?? u['fullName'] ?? u['displayName'] ?? customerName).toString();
      customerEmail = (u['email'] ?? '-').toString();
    }

    return _BookingInvoiceData(
      bookingId: widget.args.bookingId,
      status: status,
      amountPaid: amount,
      currency: currency,
      paidAt: paidAt,
      paymentMethod: paymentMethod,
      spaceName: spaceName,
      customerName: customerName,
      customerEmail: customerEmail,
      startAt: startAt,
      endAt: endAt,
    );
  }

  DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<_BookingInvoiceData>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            final data = snapshot.data!;
            final isConfirmed = data.isConfirmed;

            return Padding(
              padding: _pagePadding,
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  _StatusBanner(isConfirmed: isConfirmed),
                  const SizedBox(height: 14),
                  _InfoCard(data: data),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
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
            );
          },
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final bool isConfirmed;
  const _StatusBanner({required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    final title = isConfirmed ? 'Booking Confirmed' : 'Payment Submitted';
    final subtitle = isConfirmed
        ? 'Your booking is confirmed. Invoice is ready for download.'
        : 'Awaiting admin confirmation. You will be notified.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE083)),
      ),
      child: Row(
        children: [
          Icon(
            isConfirmed ? Icons.verified_rounded : Icons.hourglass_top,
            color: const Color(0xFFB8860B),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF7A5A00))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final _BookingInvoiceData data;
  const _InfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
          _row('Booking ID', data.bookingId),
          const SizedBox(height: 8),
          _row('Space', data.spaceName),
          const SizedBox(height: 8),
          _row('Customer', data.customerName),
          const SizedBox(height: 8),
          _row('Amount paid', '${data.currency}${data.amountPaid}'),
          const SizedBox(height: 8),
          _row('Payment method', data.paymentMethod),
          const SizedBox(height: 8),
          _row('Paid at', _fmtDateTime(data.paidAt)),
          if (data.startAt != null) ...[
            const SizedBox(height: 8),
            _row('Start time', _fmtDateTime(data.startAt!)),
          ],
          if (data.endAt != null) ...[
            const SizedBox(height: 8),
            _row('End time', _fmtDateTime(data.endAt!)),
          ],
          const SizedBox(height: 8),
          _row('Status', data.isConfirmed ? 'Confirmed' : 'Payment under review'),
          const SizedBox(height: 12),
          if (data.isConfirmed)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _downloadInvoice(data),
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

  static Future<void> _downloadInvoice(_BookingInvoiceData data) async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImage;
    try {
      final logoBytes = (await rootBundle.load(AppAssets.logo)).buffer.asUint8List();
      logoImage = pw.MemoryImage(logoBytes);
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text('Msahtak Workspace', style: const pw.TextStyle(fontSize: 11)),
                      pw.Text('Generated: ${_fmtDateTime(DateTime.now())}',
                          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 64,
                      height: 64,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                    ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.grey600),
              pw.SizedBox(height: 12),
              _pdfSectionTitle('Booking Information'),
              _pdfRow('Booking ID', data.bookingId),
              _pdfRow('Space', data.spaceName),
              _pdfRow('Customer', data.customerName),
              _pdfRow('Customer Email', data.customerEmail),
              if (data.startAt != null) _pdfRow('Start Time', _fmtDateTime(data.startAt!)),
              if (data.endAt != null) _pdfRow('End Time', _fmtDateTime(data.endAt!)),
              pw.SizedBox(height: 10),
              _pdfSectionTitle('Payment Information'),
              _pdfRow('Amount Paid', '${data.currency}${data.amountPaid}'),
              _pdfRow('Payment Method', data.paymentMethod),
              _pdfRow('Paid At', _fmtDateTime(data.paidAt)),
              _pdfRow('Status', data.isConfirmed ? 'Booking Confirmed' : 'Payment Under Review'),
              pw.SizedBox(height: 16),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  border: pw.Border.all(color: PdfColors.amber300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  data.isConfirmed
                      ? 'Your booking is confirmed. Keep this invoice for your records.'
                      : 'This invoice is generated after payment submission and will be finalized after admin confirmation.',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.Widget _pdfSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _pdfRow(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10)),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Text(
              v,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _row(String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(k, style: TextStyle(color: AppColors.textDark))),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  static String _fmtDateTime(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year} $hh:$mi';
  }
}

class _BookingInvoiceData {
  final String bookingId;
  final String status;
  final int amountPaid;
  final String currency;
  final DateTime paidAt;
  final String paymentMethod;
  final String spaceName;
  final String customerName;
  final String customerEmail;
  final DateTime? startAt;
  final DateTime? endAt;

  const _BookingInvoiceData({
    required this.bookingId,
    required this.status,
    required this.amountPaid,
    required this.currency,
    required this.paidAt,
    required this.paymentMethod,
    required this.spaceName,
    required this.customerName,
    required this.customerEmail,
    required this.startAt,
    required this.endAt,
  });

  bool get isConfirmed {
    final s = status.toLowerCase();
    return s == 'confirmed' || s == 'paid' || s == 'active' || s == 'completed';
  }
}
