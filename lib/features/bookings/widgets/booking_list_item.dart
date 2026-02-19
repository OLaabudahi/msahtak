import 'package:flutter/material.dart';

import '../data/models/booking_model.dart';

class BookingListItem extends StatelessWidget {
  const BookingListItem({
    super.key,
    required this.booking,
    required this.onView,
    this.onCancel,
    this.onRebook,
  });

  final Booking booking;
  final VoidCallback onView;

  /// ✅ فقط للـ Upcoming
  final VoidCallback? onCancel;

  /// ✅ فقط للـ Completed
  final VoidCallback? onRebook;

  static const _blue = Color(0xFF5B8FB9);

  bool get _isUpcoming => booking.status.toLowerCase() == 'upcoming';
  bool get _isCompleted => booking.status.toLowerCase() == 'completed';
  bool get _isCancelled => booking.status.toLowerCase() == 'cancelled';

  String get _dateLine => '${booking.dateText} • ${booking.timeText}';

  String get _priceLine {
    final value = booking.totalPrice % 1 == 0
        ? booking.totalPrice.toStringAsFixed(0)
        : booking.totalPrice.toStringAsFixed(2);
    return '${booking.currency}$value/day';
  }

  Widget _statusChip() {
    if (_isUpcoming) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF0),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF22C55E), width: 1.2),
        ),
        child: const Text(
          'Upcoming',
          style: TextStyle(
            color: Color(0xFF16A34A),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (_isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF7F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2AAE9B), width: 1.0),
        ),
        child: const Text(
          'Completed',
          style: TextStyle(
            color: Color(0xFF138A7B),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Cancelled',
        style: TextStyle(
          color: Color(0xFFE53935),
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    if (_isCancelled) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onView,
          style: ElevatedButton.styleFrom(
            backgroundColor: _blue,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text(
            'View',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    if (_isUpcoming) {
      return _TwoButtonsBar(
        leftText: 'View',
        leftFilled: true,
        onLeft: onView,
        rightText: 'Cancel',
        rightFilled: false,
        onRight: onCancel ?? () {},
      );
    }

    if (_isCompleted) {
      return _TwoButtonsBar(
        leftText: 'Rebook',
        leftFilled: false,
        onLeft: onRebook ?? () {},
        rightText: 'View',
        rightFilled: true,
        onRight: onView,
      );
    }

    return _TwoButtonsBar(
      leftText: 'View',
      leftFilled: true,
      onLeft: onView,
      rightText: 'Action',
      rightFilled: false,
      onRight: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x01000000) ,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: booking.imageProvider,
                      width: 92,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Name
                        Text(
                          booking.spaceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ✅ date/time
                        Text(
                          _dateLine,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 2),

                        // ✅ booking id
                        Text(
                          'Booking ID: ${booking.bookingId}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ✅ HERE: Price + Status chip on SAME ROW (like design)
                        Row(
                          children: [
                            Text(
                              _priceLine,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            _statusChip(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: Colors.grey[200]),
            _bottomButtons(),
          ],
        ),
      ),
    );
  }
}

class _TwoButtonsBar extends StatelessWidget {
  const _TwoButtonsBar({
    required this.leftText,
    required this.leftFilled,
    required this.onLeft,
    required this.rightText,
    required this.rightFilled,
    required this.onRight,
  });

  final String leftText;
  final bool leftFilled;
  final VoidCallback onLeft;

  final String rightText;
  final bool rightFilled;
  final VoidCallback onRight;

  static const _blue = Color(0xFF5B8FB9);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onLeft,
              child: Container(
                color: leftFilled ? _blue : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  leftText,
                  style: TextStyle(
                    color: leftFilled ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, color: Colors.grey[200]),
          Expanded(
            child: InkWell(
              onTap: onRight,
              child: Container(
                color: rightFilled ? _blue : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  rightText,
                  style: TextStyle(
                    color: rightFilled ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
