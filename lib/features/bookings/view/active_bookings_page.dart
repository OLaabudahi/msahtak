import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../booking_details/view/booking_details_page.dart';


class ActiveBookingsPage extends StatelessWidget {
  const ActiveBookingsPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ActiveBookingsPage());

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Active Bookings',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: uid == null
          ? const Center(child: Text('Not logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: uid)
                  .where('status', whereIn: ['approved', 'confirmed'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary));
                }

                final docs = snapshot.data?.docs ?? [];
                
                docs.sort((a, b) {
                  final at = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                  final bt = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                  return bt.compareTo(at);
                });

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event_available_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('No active bookings',
                            style: AppTextStyles.body
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final bookingId = docs[i].id;
                    return _ActiveBookingCard(
                      bookingId: bookingId,
                      data: d,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingDetailsPage.withBloc(bookingId: bookingId),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _ActiveBookingCard extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _ActiveBookingCard({
    required this.bookingId,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spaceName = data['spaceName'] as String? ??
        data['workspaceName'] as String? ??
        'Space';
    final status = data['status'] as String? ?? 'pending';
    final startTs = data['startDate'] as Timestamp?;
    final endTs = data['endDate'] as Timestamp?;

    String dateText = '--';
    String timeText = '--';
    if (startTs != null) {
      final dt = startTs.toDate();
      dateText = '${dt.day}/${dt.month}/${dt.year}';
      timeText = _fmt(dt);
      if (endTs != null) timeText += ' â€“ ${_fmt(endTs.toDate())}';
    }

    final imageUrls = (data['images'] as List?)?.cast<String>() ?? const [];
    final imageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    final totalAmount = (data['totalAmount'] as num?)?.toInt() ?? 0;
    final currency = data['currency'] as String? ?? 'â‚ھ';

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder())
                          : _placeholder(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spaceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dateText  â€¢  $timeText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$currency$totalAmount',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusBadge(status: status),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnSecondary,
                  foregroundColor: AppColors.btnSecondaryText,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                child: const Text('View',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.surface,
        child: const Icon(Icons.apartment_outlined, size: 28),
      );

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        label = 'Confirmed';
        break;
      case 'under_review':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        label = 'Under Review';
        break;
      default:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
