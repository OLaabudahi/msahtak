import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'payments_source.dart';
import '../models/payment_model.dart';
import '../models/payment_details_model.dart';

/// ظ…طµط¯ط± Firebase ظ„ظ„ظ…ط¯ظپظˆط¹ط§طھ â€” ظٹظ‚ط±ط£ ظ…ظ† bookings collection
class PaymentsFirebaseSource implements PaymentsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<PaymentModel>> fetchPayments({
    required String periodId,
    required String status,
  }) async {
    final snap = await _db.collection('bookings').get();

    return snap.docs.where((doc) {
      final d = doc.data();
      final s = (d['status'] as String? ?? '').toLowerCase();
      if (status == 'all') return true;
      return s == status.toLowerCase();
    }).map((doc) {
      final d = doc.data();
      return PaymentModel(
        id: doc.id,
        date: _formatDate(d['createdAt']),
        amount: '\$${(d['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
        status: d['status'] as String? ?? 'pending',
        userName: d['userName'] as String? ?? 'Unknown',
        bookingId: doc.id,
      );
    }).toList();
  }

  @override
  Future<PaymentDetailsModel> fetchPaymentDetails({required String paymentId}) async {
    final doc = await _db.collection('bookings').doc(paymentId).get();
    if (!doc.exists) {
      return PaymentDetailsModel(
        id: paymentId,
        date: '-',
        amount: '-',
        status: 'unknown',
        method: '-',
        reference: paymentId,
        userName: '-',
        bookingId: paymentId,
      );
    }
    final d = doc.data()!;
    return PaymentDetailsModel(
      id: doc.id,
      date: _formatDate(d['createdAt']),
      amount: '\$${(d['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
      status: d['status'] as String? ?? 'pending',
      method: d['paymentMethod'] as String? ?? 'Card',
      reference: 'REF-${doc.id.substring(0, 6).toUpperCase()}',
      userName: d['userName'] as String? ?? 'Unknown',
      bookingId: doc.id,
    );
  }

  @override
  Future<void> issueRefund({required String paymentId}) async {
    await _db.collection('bookings').doc(paymentId).update({'status': 'refunded'});
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return '-';
    try {
      final dt = (ts as Timestamp).toDate();
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return '-';
    }
  }
}


