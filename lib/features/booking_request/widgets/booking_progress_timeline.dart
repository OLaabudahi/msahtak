import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../domain/entities/booking_request_entity.dart';


class BookingProgressTimeline extends StatelessWidget {
  final BookingRequestStatus? status;

  const BookingProgressTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = _steps(status, context);

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
          Text(context.t('timelineProgress'), style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            final isLast = i == steps.length - 1;
            return _TimelineRow(
              title: s.title,
              subtitle: s.subtitle,
              state: s.state,
              drawLine: !isLast,
            );
          }),
        ],
      ),
    );
  }

  List<_Step> _steps(BookingRequestStatus? status, BuildContext ctx) {
    final sent = _Step('Request sent', 'We received your request', _StepState.done);

    if (status == null) {
      return [sent, _Step('Under review', 'The space is reviewing your request', _StepState.active), _Step('Approved', 'Proceed to payment', _StepState.todo)];
    }

    switch (status) {
      case BookingRequestStatus.pending:
        return [sent, _Step('Under review', 'Waiting for admin review', _StepState.todo), _Step('Approved', 'Proceed to payment', _StepState.todo)];
      case BookingRequestStatus.underReview:
        return [sent, _Step('Under review', 'The space reviewed your request', _StepState.active), _Step('Approved', 'Proceed to payment', _StepState.todo)];
      case BookingRequestStatus.approvedWaitingPayment:
      case BookingRequestStatus.approved:
        return [sent, _Step('Under review', 'Review completed', _StepState.done), _Step('Approved â€“ Pay now', 'Complete payment within 24 hours', _StepState.active), _Step('Payment review', 'Admin verifies payment', _StepState.todo), _Step('Confirmed', 'Booking confirmed', _StepState.todo)];
      case BookingRequestStatus.paymentUnderReview:
        return [sent, _Step('Under review', 'Review completed', _StepState.done), _Step('Payment submitted', 'Payment received', _StepState.done), _Step('Payment review', 'Admin is verifying your payment', _StepState.active), _Step('Confirmed', 'Booking confirmed', _StepState.todo)];
      case BookingRequestStatus.confirmed:
      case BookingRequestStatus.paid:
        return [sent, _Step('Under review', 'Review completed', _StepState.done), _Step('Payment submitted', 'Payment received', _StepState.done), _Step('Payment review', 'Payment verified', _StepState.done), _Step('Confirmed', 'Booking confirmed!', _StepState.done)];
      case BookingRequestStatus.expired:
        return [sent, _Step('Under review', 'Review completed', _StepState.done), _Step('Expired', 'Payment deadline passed â€“ booking cancelled', _StepState.active)];
      case BookingRequestStatus.cancelled:
        return [sent, _Step('Cancelled', 'Booking was cancelled', _StepState.active)];
      case BookingRequestStatus.rejected:
        return [sent, _Step('Rejected', 'Booking request was rejected', _StepState.active)];
      default:
        return [sent, _Step('Under review', 'The space is reviewing your request', _StepState.active), _Step('Approved', 'Proceed to payment', _StepState.todo)];
    }
  }
}

enum _StepState { todo, active, done }

class _Step {
  final String title;
  final String subtitle;
  final _StepState state;
  const _Step(this.title, this.subtitle, this.state);
}

class _TimelineRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final _StepState state;
  final bool drawLine;

  const _TimelineRow({required this.title, required this.subtitle, required this.state, required this.drawLine});

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(state);
    final color = _colorFor(state);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(height: 26, width: 26, decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: Icon(icon, size: 16, color: Colors.white)),
            if (drawLine) Container(width: 2, height: 34, color: AppColors.inputBorder),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: AppColors.textDark, fontSize: 12)),
              const SizedBox(height: 14),
            ]),
          ),
        ),
      ],
    );
  }

  IconData _iconFor(_StepState s) {
    switch (s) {
      case _StepState.done: return Icons.check;
      case _StepState.active: return Icons.timelapse;
      case _StepState.todo: return Icons.circle_outlined;
    }
  }

  Color _colorFor(_StepState s) {
    switch (s) {
      case _StepState.done: return AppColors.approvedText;
      case _StepState.active: return AppColors.amber;
      case _StepState.todo: return AppColors.textMuted;
    }
  }
}


