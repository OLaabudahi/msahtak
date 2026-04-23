import 'package:flutter/material.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../core/widgets/app_button.dart';
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

  bool get _isUpcoming =>
      booking.status.toLowerCase() == 'upcoming' ||
          booking.status.toLowerCase() == 'confirmed';
  bool get _isAwaitingConfirmation =>
      booking.status.toLowerCase() == 'awaiting_confirmation';
  bool get _isAwaitingPayment =>
      booking.status.toLowerCase() == 'awaiting_payment';

  bool get _isCompleted =>
      booking.status.toLowerCase() == 'completed';

  bool get _isCancelled =>
      booking.status.toLowerCase() == 'cancelled';

  bool get _isActiveNow {
    final start = booking.startAt;
    final end = booking.endAt;
    if (start == null || end == null) return false;

    final now = DateTime.now();
    final raw = booking.rawStatus.toLowerCase();
    final isEligible = raw == 'confirmed' || raw == 'paid' || raw == 'active';
    if (!isEligible) return false;

    return (now.isAtSameMomentAs(start) || now.isAfter(start)) && now.isBefore(end);
  }

  String _dateLine() => booking.dateText;

  String _priceLine(BuildContext context) {
    final value = booking.totalPrice % 1 == 0
        ? booking.totalPrice.toStringAsFixed(0)
        : booking.totalPrice.toStringAsFixed(2);

    return '${booking.currency}$value${context.t('pricePerDay')}';
  }

  Widget _statusChip(BuildContext context) {
    if (_isAwaitingPayment) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.amber, width: 1.0),
        ),
        child: Text(
          context.t('bookingsTabAwaitingPayment'),
          style: const TextStyle(
            color: AppColors.warningText,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (booking.status.toLowerCase() == 'awaiting_confirmation') {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.reviewStatusBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.secondary, width: 1.0),
        ),
        child: Text(
          context.t('bookingStatusAwaitingConfirmation'),
          style: const TextStyle(
            color: AppColors.reviewStatusText,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (_isActiveNow) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.approvedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.approvedBorder, width: 1.2),
        ),
        child: Text(
          context.t('activeStatusLabel'),
          style: TextStyle(
            color: AppColors.approvedText,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (booking.status.toLowerCase() == 'confirmed') {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.approvedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.approvedBorder, width: 1.2),
        ),
        child: Text(
          context.t('bookingStatusConfirmed'),
          style: TextStyle(
            color: AppColors.approvedText,
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
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.amber, width: 1.2),
        ),
        child: Text(
          context.t('bookingStatusUpcoming'),
          style: const TextStyle(
            color: AppColors.warningText,
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
          color: AppColors.approvedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.approvedBorder, width: 1.0),
        ),
        child: Text(
          context.t('bookingStatusCompleted'),
          style: const TextStyle(
            color: AppColors.approvedText,
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
        color: AppColors.rejectedBg,
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
      return AppButton(
        label: context.t('view'),
        onPressed: onView,
        type: AppButtonType.secondary,
        borderRadius: 0,
      );
    }

    if (_isUpcoming || _isAwaitingConfirmation || _isAwaitingPayment) {
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
        color: AppColors.btnSecondaryText,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
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
                        if (_isCancelled &&
                            ((booking.cancelledBy ?? '').isNotEmpty ||
                                (booking.cancelReason ?? '').isNotEmpty ||
                                (booking.cancellationStage ?? '').isNotEmpty)) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${context.t('cancelledByLabel')}: ${booking.cancelledBy?.isNotEmpty == true ? booking.cancelledBy : '-'}',
                            style: TextStyle(fontSize: 11.5, color: AppColors.textDark),
                          ),
                          Text(
                            '${context.t('cancellationStageLabel')}: ${booking.cancellationStage?.isNotEmpty == true ? booking.cancellationStage : '-'}',
                            style: TextStyle(fontSize: 11.5, color: AppColors.textDark),
                          ),
                          Text(
                            '${context.t('cancelReasonLabel')}: ${booking.cancelReason?.isNotEmpty == true ? booking.cancelReason : '-'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.5, color: AppColors.textDark),
                          ),
                        ],
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
import '../../../core/widgets/app_button.dart';
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

  /// Upcoming-only helper.
  final VoidCallback? onCancel;

  /// Completed-only helper.
  final VoidCallback? onRebook;

  bool get _isUpcoming => booking.status.toLowerCase() == 'upcoming' || booking.status.toLowerCase() == 'confirmed';
  bool get _isCompleted => booking.status.toLowerCase() == 'completed';
  bool get _isCancelled => booking.status.toLowerCase() == 'cancelled';

  String _dateLine() => '${booking.dateText} • ${booking.timeText}';

  String _priceLine(BuildContext context) {
    final value = booking.totalPrice % 1 == 0
        ? booking.totalPrice.toStringAsFixed(0)
        : booking.totalPrice.toStringAsFixed(2);
    return '${booking.currency}$value${context.t('pricePerDay')}';
  }

  Widget _statusChip(BuildContext context) {
    if (_isActiveNow) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.approvedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.approvedBorder, width: 1.2),
        ),
        child: Text(
          context.t('activeStatusLabel'),
          style: TextStyle(
            color: AppColors.approvedText,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      );
    }

    if (booking.status.toLowerCase() == 'confirmed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.approvedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.approvedBorder, width: 1.2),
        ),
        child: const Text(
          'Confirmed',
          style: TextStyle(
            color: AppColors.approvedText,
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
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.amber, width: 1.2),
        ),
        child: Text(
          context.t('bookingStatusUpcoming'),
          style: const TextStyle(
            color: AppColors.warningText,
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
            color: AppColors.approvedText,
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
      return AppButton(
        label: context.t('view'),
        onPressed: onView,
        type: AppButtonType.secondary,
        borderRadius: 0,
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
        color: AppColors.btnSecondaryText,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
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
                        // Name
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

                        // Date/time
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

                        // Booking id
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

                        // Price + status chip
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
