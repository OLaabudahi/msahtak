import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

import '../../../domain/entities/booking_request_entity.dart';

class BookingProgressTimeline extends StatelessWidget {
  final BookingRequestStatus? status;

  const BookingProgressTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = _steps(status);

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
          const Text('Progress', style: TextStyle(fontWeight: FontWeight.w800)),
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

  List<_Step> _steps(BookingRequestStatus? status) {
    // Map status to steps
    final sent = _Step('Request sent', 'We received your request', _StepState.done);

    if (status == null) {
      return [sent, const _Step('Under review', 'Checking availability', _StepState.active), const _Step('Approved', 'Proceed to payment', _StepState.todo)];
    }

    switch (status) {
      case BookingRequestStatus.pending:
        return [sent, const _Step('Under review', 'Waiting to start review', _StepState.todo), const _Step('Approved', 'Proceed to payment', _StepState.todo)];
      case BookingRequestStatus.underReview:
        return [sent, const _Step('Under review', 'Checking availability', _StepState.active), const _Step('Approved', 'Proceed to payment', _StepState.todo)];
      case BookingRequestStatus.approved:
        return [sent, const _Step('Under review', 'Completed', _StepState.done), const _Step('Approved', 'Proceed to payment', _StepState.active)];
      case BookingRequestStatus.paid:
        return [sent, const _Step('Under review', 'Completed', _StepState.done), const _Step('Approved', 'Payment completed', _StepState.done)];
      case BookingRequestStatus.cancelled:
        return [sent, const _Step('Cancelled', 'Request cancelled by user', _StepState.active)];
      case BookingRequestStatus.rejected:
        return [sent, const _Step('Rejected', 'Request rejected', _StepState.active)];
      default:
        return [sent, const _Step('Under review', 'Checking availability', _StepState.active), const _Step('Approved', 'Proceed to payment', _StepState.todo)];
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

  const _TimelineRow({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.drawLine,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(state);
    final color = _colorFor(state);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            if (drawLine)
              Container(
                width: 2,
                height: 34,
                color: AppColors.inputBorder,
              ),
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
      case _StepState.done:
        return Icons.check;
      case _StepState.active:
        return Icons.timelapse;
      case _StepState.todo:
        return Icons.circle_outlined;
    }
  }

  Color _colorFor(_StepState s) {
    switch (s) {
      case _StepState.done:
        return AppColors.approvedText;
      case _StepState.active:
        return AppColors.amber;
      case _StepState.todo:
        return AppColors.textMuted;
    }
  }
}

