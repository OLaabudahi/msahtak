import '../../../../core/services/firestore_api.dart';
import '../../../../services/auth_service.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../constants/app_assets.dart';

class PaymentsReceiptsFirebaseSource {
  final FirestoreApi api;
  final AuthService authService;

  PaymentsReceiptsFirebaseSource({
    required this.api,
    required this.authService,
  });

  String? get _uid {
    final uid = authService.currentUser?.uid;
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  String get currentUserName =>
      (authService.currentUser?.displayName ?? '').trim();
  String get currentUserEmail =>
      (authService.currentUser?.email ?? '').trim();

  Future<List<Map<String, dynamic>>> fetchUserBookingsForReceipts() async {
    final uid = _uid;
    if (uid == null) return const [];

    final byUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'userId',
      value: uid,
      limit: 300,
    );

    final byLegacyUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'user_id',
      value: uid,
      limit: 300,
    );

    final merged = <String, Map<String, dynamic>>{};
    for (final row in [...byUserId, ...byLegacyUserId]) {
      final id = (row['id'] ?? '').toString();
      if (id.isEmpty) continue;
      merged[id] = row;
    }

    return merged.values.toList(growable: false);
  }

  Future<Uint8List> generateInvoicePdf({
    required String bookingId,
    required String spaceName,
    required String userName,
    required String userEmail,
    required DateTime startDate,
    required DateTime endDate,
    required String paymentMethod,
    required double totalPrice,
    required String currency,
    required String status,
    required DateTime createdAt,
  }) async {
    final pdf = pw.Document();
    final logoData = await rootBundle.load(AppAssets.logo);
    final logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    String fmt(DateTime value) {
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(value.day)}/${two(value.month)}/${value.year} ${two(value.hour)}:${two(value.minute)}';
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.08,
                    child: pw.Image(logoImage, width: 280),
                  ),
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                              fontSize: 28,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(spaceName),
                          pw.Text('Generated At: ${fmt(createdAt)}'),
                        ],
                      ),
                      pw.Image(logoImage, width: 52, height: 52),
                    ],
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Booking Information',
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Divider(),
                  _kv('Booking ID', bookingId),
                  _kv('Space Name', spaceName),
                  _kv('Customer Name', userName.isEmpty ? '-' : userName),
                  _kv('Email', userEmail.isEmpty ? '-' : userEmail),
                  _kv('Start Date', fmt(startDate)),
                  _kv('End Date', fmt(endDate)),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Payment Information',
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Divider(),
                  _kv('Amount Paid', '${totalPrice.toStringAsFixed(2)} ${_safeCurrencyText(currency)}'),
                  _kv('Payment Method', paymentMethod),
                  _kv('Status', status),
                  _kv('Payment Date', fmt(createdAt)),
                  pw.Spacer(),
                  pw.Text(
                    'Invoice generated after payment submission and will be finalized after confirmation.',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<File> saveInvoicePdf({
    required Uint8List bytes,
    required String bookingId,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice_$bookingId.pdf');
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<void> shareInvoiceFile(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice',
    );
  }

  pw.Widget _kv(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: const pw.TextStyle(color: PdfColors.grey700),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _safeCurrencyText(String currency) {
    final trimmed = currency.trim();
    if (trimmed.isEmpty) return 'USD';

    final upper = trimmed.toUpperCase();
    if (RegExp(r'^[A-Z]{3}$').hasMatch(upper)) return upper;

    switch (trimmed) {
      case '\$':
        return 'USD';
      case '€':
        return 'EUR';
      case '£':
        return 'GBP';
      case '₪':
        return 'ILS';
      default:
        return 'USD';
    }
  }
}
