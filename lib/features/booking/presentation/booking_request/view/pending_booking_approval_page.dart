import 'package:flutter/material.dart';

import '../../../domain/entities/booking_request_entity.dart';
import '../../../booking_feature_routes.dart';
import '../widgets/booking_request_summary_card.dart';

class PendingBookingApprovalPage extends StatelessWidget {
  final BookingRequestEntity request;

  const PendingBookingApprovalPage({super.key, required this.request});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    final canViewStatus = request.requestId.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending booking approval'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: _pagePadding,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _SuccessCard(
                title: 'Request sent successfully',
                subtitle: 'Your booking request is under review',
              ),
              const SizedBox(height: 14),
              BookingRequestSummaryCard(request: request),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: canViewStatus
                      ? () => Navigator.of(context).push(
                    BookingFeatureRoutes.bookingStatus(requestId: request.requestId),
                  )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: const Text(
                    'View booking status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // مكانها الحقيقي: Navigator.popUntil(Home)
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    side: const BorderSide(color: Color(0xFFEAEAEA)),
                  ),
                  child: const Text('Go to Home'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SuccessCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFE2BE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }
}

