import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

import '../data/models/booking_model.dart';

class BookingListItem extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.onTap,
  });

  /// ✅ دالة: لون badge حسب حالة الحجز
  Color _statusColor() {
    switch (booking.status) {
      case 'upcoming':
        return const Color(0xFF2563EB);
      case 'completed':
        return const Color(0xFF16A34A);
      case 'cancelled':
      default:
        return const Color(0xFFDC2626);
    }
  }

  /// ✅ دالة: نص badge
  String _statusText() {
    switch (booking.status) {
      case 'upcoming':
        return 'Upcoming';
      case 'completed':
        return 'Completed';
      case 'cancelled':
      default:
        return 'Cancelled';
    }
  }

  /// ✅ دالة: تنسيق السعر
  String _money() => '${booking.currency}${booking.totalPrice.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6EEF7)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                booking.imageAsset ?? 'assets/images/home.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
              // ✅ API READY (كومنت)
              // child: booking.imageUrl != null
              //   ? Image.network(booking.imageUrl!, width: 64, height: 64, fit: BoxFit.cover)
              //   : Image.asset(booking.imageAsset ?? ..., width: 64, height: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.spaceName, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(
                    '${booking.dateText} • ${booking.timeText}',
                    style: const TextStyle(color: AppColors.subtext, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _statusText(),
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 11.5),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _money(),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
