import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

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
            const AdminAppBar(title: 'Payment Review', subtitle: 'Verify incoming payments'),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: AdminText.body14(color: AdminColors.danger)));
                  }
                  // ترتيب محلي بـ paidAt تنازلياً بدون Composite Index
                  final docs = List.of(snapshot.data?.docs ?? [])
                    ..sort((a, b) {
                      final at = (a.data()['paidAt'] as dynamic)?.millisecondsSinceEpoch ?? 0;
                      final bt = (b.data()['paidAt'] as dynamic)?.millisecondsSinceEpoch ?? 0;
                      return bt.compareTo(at);
                    });
                  if (docs.isEmpty) {
                    return Center(
                      child: Text('No payments pending review', style: AdminText.body16(color: AdminColors.black40)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _PaymentReviewCard(doc: docs[i]),
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
      await FirebaseFirestore.instance.collection('bookings').doc(widget.doc.id).update({
        'status': 'confirmed',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // إشعار لليوزر
      final d = widget.doc.data();
      final uid = d['userId'] as String? ?? '';
      final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
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
        'updatedAt': FieldValue.serverTimestamp(),
      });
      final d = widget.doc.data();
      // إعادة المقعد للمساحة عند رفض الدفع
      final spaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
      if (spaceId.isNotEmpty) {
        try {
          final wsRef = db.collection('workspaces').doc(spaceId);
          await db.runTransaction((tx) async {
            final wsSnap = await tx.get(wsRef);
            if (!wsSnap.exists) return;
            final current = (wsSnap.data()!['availableSeats'] as num?)?.toInt() ?? 0;
            final total = (wsSnap.data()!['totalSeats'] as num?)?.toInt() ?? 0;
            tx.update(wsRef, {'availableSeats': total > 0 ? (current + 1).clamp(0, total) : current + 1});
          });
        } catch (_) {}
      }
      final uid = d['userId'] as String? ?? '';
      final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': uid,
          'title': 'Payment Rejected',
          'subtitle': 'Your payment for $spaceName was not verified. Please contact support.',
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
    final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
    final userName = d['userName'] as String? ?? 'User';
    final amount = d['totalAmount']?.toString() ?? '-';
    final currency = d['currency'] as String? ?? '₪';
    final method = d['paymentMethod'] as String? ?? '-';
    final paidTs = d['paidAt'] as Timestamp?;
    final paidAt = paidTs != null ? _fmt(paidTs.toDate()) : '-';

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
          Row(children: [
            Expanded(child: Text(spaceName, style: AdminText.body16(w: FontWeight.w700))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(8)),
              child: Text('Under Review', style: AdminText.label12(color: const Color(0xFFB8860B), w: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 8),
          _row('User', userName),
          _row('Amount', '$currency$amount'),
          _row('Method', method),
          _row('Paid at', paidAt),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2)))
          else
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: _reject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminColors.danger,
                  side: const BorderSide(color: AdminColors.danger),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Reject'),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              )),
            ]),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(width: 80, child: Text(k, style: AdminText.label12(color: AdminColors.black40))),
        Expanded(child: Text(v, style: AdminText.body14())),
      ]),
    );
  }

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year} $hh:$mi';
  }
}
