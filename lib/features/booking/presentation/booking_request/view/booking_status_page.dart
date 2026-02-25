import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../booking_feature_routes.dart';
import '../../../domain/entities/booking_request_entity.dart';
import '../bloc/booking_request_bloc.dart';
import '../bloc/booking_request_event.dart';
import '../bloc/booking_request_state.dart';
import '../widgets/booking_progress_timeline.dart';
import '../widgets/booking_request_summary_card.dart';

class BookingStatusPage extends StatelessWidget {
  final String requestId;

  const BookingStatusPage({super.key, required this.requestId});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<BookingRequestBloc, BookingRequestState>(
          listenWhen: (p, c) => p.uiStatus != c.uiStatus,
          listener: (context, state) {
            if (state.uiStatus == BookingRequestUiStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            final req = state.createdRequest;
            final isBusy = state.uiStatus == BookingRequestUiStatus.loading;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookingRequestBloc>().add(StatusRefreshRequested(requestId));
              },
              child: ListView(
                padding: _pagePadding,
                children: [
                  if (isBusy) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 10),
                  _StatusHeaderCard(request: req),
                  const SizedBox(height: 14),

                  if (req != null && req.status == BookingRequestStatus.approved) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.approvedBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.approvedBorder),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified, color: AppColors.approvedText),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Booking is approved. Please proceed to payment.',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  BookingProgressTimeline(status: req?.status),
                  const SizedBox(height: 14),
                  if (req != null) BookingRequestSummaryCard(request: req),
                  const SizedBox(height: 16),

                  // Actions (حسب الحالة)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => context.read<BookingRequestBloc>().add(StatusRefreshRequested(requestId)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.amber,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                            ),
                            child: const Text('Refresh status'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (req != null && req.canCancelBeforeApproval) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => context.read<BookingRequestBloc>().add(CancelRequestPressed(requestId)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          side: const BorderSide(color: AppColors.inputBorder),
                        ),
                        child: const Text('Cancel request'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null && req.status == BookingRequestStatus.approved) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          BookingFeatureRoutes.payment(requestId: requestId),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: const Text('Go to payment'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null && req.status == BookingRequestStatus.paid) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.approvedBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.approvedBorder),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle, color: AppColors.approvedText),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Paid successfully. You can view booking details from your bookings list.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusHeaderCard extends StatelessWidget {
  final BookingRequestEntity? request;

  const _StatusHeaderCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final status = request?.status;
    final badge = _badgeFor(status);

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Booking request',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badge.bg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(color: badge.fg, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request?.statusHint ?? 'Pull to refresh for latest status',
            style: TextStyle(color: AppColors.textDark, fontSize: 12),
          ),
        ],
      ),
    );
  }

  _Badge _badgeFor(BookingRequestStatus? status) {
    switch (status) {
      case BookingRequestStatus.pending:
        return const _Badge('Pending', AppColors.warningBg, AppColors.warningText);
      case BookingRequestStatus.underReview:
        return const _Badge('Under review', AppColors.reviewStatusBg, AppColors.reviewStatusText);
      case BookingRequestStatus.approved:
        return const _Badge('Approved', AppColors.approvedBg, AppColors.approvedText);
      case BookingRequestStatus.rejected:
        return const _Badge('Rejected', AppColors.rejectedBg, AppColors.danger);
      case BookingRequestStatus.cancelled:
        return const _Badge('Cancelled', AppColors.neutralBadgeBg, AppColors.textDark);
      case BookingRequestStatus.paid:
        return const _Badge('Paid', AppColors.approvedBg, AppColors.approvedText);
      default:
        return const _Badge('Loading', AppColors.neutralBadgeBg, AppColors.textDark);
    }
  }
}

class _Badge {
  final String label;
  final Color bg;
  final Color fg;

  const _Badge(this.label, this.bg, this.fg);
}

