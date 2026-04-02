import 'package:flutter/material.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

import '../domain/entities/booking_entity.dart';
import 'two_buttons_bar.dart';

class BookingListItem extends StatelessWidget {
  const BookingListItem({
    super.key,
    required this.booking,
    required this.onView,
    this.onCancel,
    this.onRebook,
  });

  final BookingEntity booking;
  final VoidCallback onView;
  final VoidCallback? onCancel;
  final VoidCallback? onRebook;

  static const _blue = AppColors.btnSecondary;

  bool get _isUpcoming =>
      booking.status.toLowerCase() == 'upcoming' ||
          booking.status.toLowerCase() == 'confirmed';

  bool get _isCompleted =>
      booking.status.toLowerCase() == 'completed';

  bool get _isCancelled =>
      booking.status.toLowerCase() == 'cancelled';

  String _dateLine() =>
      '${booking.dateText} â€¢ ${booking.timeText}';

  String _priceLine(BuildContext context) {
    final value = booking.totalPrice % 1 == 0
        ? booking.totalPrice.toStringAsFixed(0)
        : booking.totalPrice.toStringAsFixed(2);

    return '${booking.currency}$value${context.t('pricePerDay')}';
  }

  Widget _statusChip(BuildContext context) {
    if (booking.status.toLowerCase() == 'confirmed') {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF0),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFF22C55E), width: 1.2),
        ),
        child: const Text(
          'Confirmed',
          style: TextStyle(
            color: Color(0xFF16A34A),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (_isUpcoming) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFFF59E0B), width: 1.2),
        ),
        child: Text(
          context.t('bookingStatusUpcoming'),
          style: const TextStyle(
            color: Color(0xFF92400E),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (_isCompleted) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF7F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFF2AAE9B), width: 1.0),
        ),
        child: Text(
          context.t('bookingStatusCompleted'),
          style: const TextStyle(
            color: Color(0xFF138A7B),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        context.t('bookingStatusCancelled'),
        style: const TextStyle(
          color: AppColors.danger,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
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
          child: Text(
            context.t('view'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    if (_isUpcoming) {
      return TwoButtonsBar(
        leftText: context.t('view'),
        leftFilled: true,
        onLeft: onView,
        rightText: context.t('cancel'),
        rightFilled: false,
        onRight: onCancel ?? () {},
      );
    }

    if (_isCompleted) {
      return TwoButtonsBar(
        leftText: context.t('rebook'),
        leftFilled: false,
        onLeft: onRebook ?? () {},
        rightText: context.t('view'),
        rightFilled: true,
        onRight: onView,
      );
    }

    return TwoButtonsBar(
      leftText: context.t('view'),
      leftFilled: true,
      onLeft: onView,
      rightText: context.t('rebook'),
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
            color: Colors.black.withOpacity(0.06),
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
                        Text(
                          booking.spaceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dateLine(),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${context.t('bookingIdLabel')} ${booking.bookingId}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _priceLine(context),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _statusChip(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.borderLight),
            _bottomButtons(context),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

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

  /// âœ… ظپظ‚ط· ظ„ظ„ظ€ Upcoming
  final VoidCallback? onCancel;

  /// âœ… ظپظ‚ط· ظ„ظ„ظ€ Completed
  final VoidCallback? onRebook;

  static const _blue = AppColors.btnSecondary;

  bool get _isUpcoming => booking.status.toLowerCase() == 'upcoming' || booking.status.toLowerCase() == 'confirmed';
  bool get _isCompleted => booking.status.toLowerCase() == 'completed';
  bool get _isCancelled => booking.status.toLowerCase() == 'cancelled';

  String _dateLine() => '${booking.dateText} â€¢ ${booking.timeText}';

  String _priceLine(BuildContext context) {
    final value = booking.totalPrice % 1 == 0
        ? booking.totalPrice.toStringAsFixed(0)
        : booking.totalPrice.toStringAsFixed(2);
    return '${booking.currency}$value${context.t('pricePerDay')}';
  }

  Widget _statusChip(BuildContext context) {
    if (booking.status.toLowerCase() == 'confirmed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF0),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF22C55E), width: 1.2),
        ),
        child: const Text(
          'Confirmed',
          style: TextStyle(
            color: Color(0xFF16A34A),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }
    if (_isUpcoming) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
        ),
        child: Text(
          context.t('bookingStatusUpcoming'),
          style: const TextStyle(
            color: Color(0xFF92400E),
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
          color: Color(0xFFDFF7F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xFF2AAE9B), width: 1.0),
        ),
        child: Text(
          context.t('bookingStatusCompleted'),
          style: const TextStyle(
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
        color: Color(0xFFFFE3E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        context.t('bookingStatusCancelled'),
        style: const TextStyle(
          color: AppColors.danger,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
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
          child: Text(
            context.t('view'),
            style: const TextStyle(
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
        leftText: context.t('view'),
        leftFilled: true,
        onLeft: onView,
        rightText: context.t('cancel'),
        rightFilled: false,
        onRight: onCancel ?? () {},
      );
    }

    if (_isCompleted) {
      return _TwoButtonsBar(
        leftText: context.t('rebook'),
        leftFilled: false,
        onLeft: onRebook ?? () {},
        rightText: context.t('view'),
        rightFilled: true,
        onRight: onView,
      );
    }

    return _TwoButtonsBar(
      leftText: context.t('view'),
      leftFilled: true,
      onLeft: onView,
      rightText: context.t('rebook'),
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
            color: Colors.black.withOpacity(0.06),
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
                        // âœ… Name
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

                        // âœ… date/time
                        Text(
                          _dateLine(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // âœ… booking id
                        Text(
                          '${context.t('bookingIdLabel')} ${booking.bookingId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // âœ… Price + Status chip
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _priceLine(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _statusChip(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: AppColors.borderLight),
            _bottomButtons(context),
          ],
        ),
      ),
    );
  }
}
*/


