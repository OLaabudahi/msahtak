import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

/// صفحة مراجعة المدفوعات للأدمن
/// تعرض الحجوزات التي في حالة payment_under_review
class PaymentReviewPage extends StatefulWidget {
  const PaymentReviewPage({super.key});

  static Widget withBloc() => const PaymentReviewPage();

  @override
  State<PaymentReviewPage> createState() => _PaymentReviewPageState();
}

class _PaymentReviewPageState extends State<PaymentReviewPage> {
  // الـ stream يُنشأ مرة واحدة فقط في initState — لا يتأثر بإعادة بناء الـ widget
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('bookings')
        .where('status', isEqualTo: 'payment_under_review')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminAppBar(
              title: context.t('adminPaymentReview'),
              subtitle: context.t('adminPaymentReviewSubtitle'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: AdminText.body14(color: AdminColors.danger),
                      ),
                    );
                  }
                  // ترتيب محلي بـ paidAt تنازلياً بدون Composite Index
                  final docs = List.of(snapshot.data?.docs ?? [])
                    ..sort((a, b) {
                      final at =
                          (a.data()['paidAt'] as dynamic)
                              ?.millisecondsSinceEpoch ??
                          0;
                      final bt =
                          (b.data()['paidAt'] as dynamic)
                              ?.millisecondsSinceEpoch ??
                          0;
                      return bt.compareTo(at);
                    });
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        context.t('adminNoPaymentsPending'),
                        style: AdminText.body16(color: AdminColors.black40),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _PaymentReviewCard(doc: docs[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentReviewCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const _PaymentReviewCard({required this.doc});

  @override
  State<_PaymentReviewCard> createState() => _PaymentReviewCardState();
}

class _PaymentReviewCardState extends State<_PaymentReviewCard> {
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.doc.id)
          .update({
            'status': 'confirmed',
            'statusHint': 'Payment verified by space owner. Booking confirmed.',
            'updatedAt': FieldValue.serverTimestamp(),
          });

      final d = widget.doc.data();
      final uid = d['userId'] as String? ?? '';
      final spaceName =
          d['spaceName'] as String? ?? 'Space';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': uid,
          'title': 'Booking Confirmed',
          'subtitle': 'Your booking for $spaceName has been confirmed!',
          'type': 'bookingApproved',
          'requestId': widget.doc.id,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reject() async {
    setState(() => _loading = true);
    try {
      final db = FirebaseFirestore.instance;
      await db.collection('bookings').doc(widget.doc.id).update({
        'status': 'rejected',
        'statusHint': 'Payment rejected by space owner review.',
        'cancelledBy': {'role': 'space_owner'},
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancellationStage': 'after_payment',
        'cancellationReason': 'Payment was not verified by admin review.',
        'cancellationCompensation': 'Compensation status: pending review.',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      final d = widget.doc.data();

      final spaceId = (d['spaceId'] ?? '') as String;
      if (spaceId.isNotEmpty) {
        try {
          final wsRef = db.collection('spaces').doc(spaceId);
          await db.runTransaction((tx) async {
            final wsSnap = await tx.get(wsRef);
            if (!wsSnap.exists) return;
            final current =
                (wsSnap.data()!['availableSeats'] as num?)?.toInt() ?? 0;
            final total = (wsSnap.data()!['totalSeats'] as num?)?.toInt() ?? 0;
            tx.update(wsRef, {
              'availableSeats': total > 0
                  ? (current + 1).clamp(0, total)
                  : current + 1,
            });
          });
        } catch (_) {}
      }
      final uid = d['userId'] as String? ?? '';
      final spaceName =
          d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': uid,
          'title': 'Payment Rejected',
          'subtitle':
              'Your payment for $spaceName was not verified. Please contact support.',
          'type': 'bookingRejected',
          'requestId': widget.doc.id,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doc.data();
    final spaceName =
        d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
    final userName = d['userName'] as String? ?? 'User';
    final amount = d['totalAmount']?.toString() ?? '-';
    final currency = d['currency'] as String? ?? '₪';
    final method = d['paymentMethodName'] as String? ?? d['paymentMethod'] as String? ?? '-';
    final paidTs = d['paidAt'] as Timestamp?;
    final paidAt = paidTs != null ? _fmt(paidTs.toDate()) : '-';
    final receiptUrl = d['paymentReceiptUrl'] as String?;
    final cardLast4 = d['cardLast4'] as String?;
    final cardHolder = d['cardHolder'] as String?;
    final cardExpiry = d['cardExpiry'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.black15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  spaceName,
                  style: AdminText.body16(w: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.t('adminUnderReview'),
                  style: AdminText.label12(
                    color: const Color(0xFFB8860B),
                    w: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _row(context.t('adminPaymentUser'), userName),
          _row(context.t('adminPaymentAmount'), '$currency$amount'),
          _row(context.t('adminPaymentMethod'), method),
          _row(context.t('adminPaymentPaidAt'), paidAt),
          const SizedBox(height: 8),
          // ── بيانات البطاقة أو إشعار الدفع ──
          if (cardLast4 != null && cardLast4.isNotEmpty)
            _CardInfoSection(
              cardLast4: cardLast4,
              cardHolder: cardHolder,
              cardExpiry: cardExpiry,
            )
          else
            _ReceiptSection(receiptUrl: receiptUrl),
          const SizedBox(height: 12),
          if (_loading)
            const Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AdminColors.danger,
                      side: const BorderSide(color: AdminColors.danger),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(context.t('adminReject')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      context.t('adminConfirm'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ]),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              k,
              style: AdminText.label12(color: AdminColors.black40),
            ),
          ),
          Expanded(child: Text(v, style: AdminText.body14())),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${dt.year} $hh:$mi';
  }

}

/// ويدجت عرض بيانات البطاقة في كارد مراجعة الأدمن
class _CardInfoSection extends StatelessWidget {
  final String cardLast4;
  final String? cardHolder;
  final String? cardExpiry;
  const _CardInfoSection({required this.cardLast4, this.cardHolder, this.cardExpiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBD6F7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card, size: 18, color: Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '**** **** **** $cardLast4',
                  style: AdminText.body14(
                    color: const Color(0xFF1565C0),
                    w: FontWeight.w700,
                  ),
                ),
                if (cardHolder != null && cardHolder!.isNotEmpty)
                  Text(
                    cardHolder!,
                    style: AdminText.label12(color: AdminColors.black40),
                  ),
                if (cardExpiry != null && cardExpiry!.isNotEmpty)
                  Text(
                    'Exp: $cardExpiry',
                    style: AdminText.label12(color: AdminColors.black40),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ويدجت عرض إشعار الدفع في كارد مراجعة الأدمن
class _ReceiptSection extends StatelessWidget {
  final String? receiptUrl;
  const _ReceiptSection({this.receiptUrl});

  @override
  Widget build(BuildContext context) {
    if (receiptUrl == null || receiptUrl!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AdminColors.bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AdminColors.black15),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 16,
              color: AdminColors.black40,
            ),
            const SizedBox(width: 8),
            Text(
              context.t('adminNoReceipt'),
              style: AdminText.body14(color: AdminColors.black40),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t('adminPaymentReceipt'),
          style: AdminText.label12(color: AdminColors.black40),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: receiptUrl!.startsWith('data:')
              ? Image.memory(
                  base64Decode(receiptUrl!.split(',').last),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  receiptUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFBBD6F7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Color(0xFF1565C0),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.t('adminViewReceipt'),
                            style: AdminText.body14(
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
