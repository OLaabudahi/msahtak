import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/booking_request_entity.dart';
import '../domain/entities/booking_status.dart';

class BookingRequestCard extends StatelessWidget {
  final BookingRequestEntity booking;
  final VoidCallback onOpenDetails;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingRequestCard({
    super.key,
    required this.booking,
    required this.onOpenDetails,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenDetails,
      borderRadius: BorderRadius.circular(12),
      child: AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(color: AdminColors.primaryBlue, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    booking.userAvatar,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminText.body16(color: Colors.white, w: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: AdminSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(booking.space, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AdminSpace.s12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AdminColors.black02, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _KV(k: 'Date', v: booking.date)),
                      const SizedBox(width: 8),
                      Expanded(child: _KV(k: 'Duration', v: booking.duration)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _KV(k: 'Time', v: booking.time, twoLines: true),
                ],
              ),
            ),
            const SizedBox(height: AdminSpace.s12),
            AdminTag(text: booking.plan, tint: AdminColors.primaryAmber.withOpacity(0.15), textColor: AdminColors.primaryAmber),
            if (booking.status == BookingStatus.pending) ...[
              const SizedBox(height: AdminSpace.s12),
              Row(
                children: [
                  Expanded(child: AdminButton.filled(label: 'Accept', onTap: onAccept, bg: AdminColors.success)),
                  const SizedBox(width: AdminSpace.s8),
                  Expanded(child: AdminButton.filled(label: 'Reject', onTap: onReject, bg: AdminColors.danger)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _KV extends StatelessWidget {
  final String k;
  final String v;
  final bool twoLines;
  const _KV({required this.k, required this.v, this.twoLines = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
        const SizedBox(height: 2),
        Text(v, maxLines: twoLines ? 2 : 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600)),
      ],
    );
  }
}

extension on AdminSpace {
  static const s12 = 12.0;
}
