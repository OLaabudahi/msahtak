import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../core/i18n/app_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_injector.dart';
import '../../../payment/view/payment_routes.dart';
import '../../bloc/booking_request_bloc.dart';
import '../../bloc/booking_request_event.dart';
import '../../bloc/booking_request_state.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../widgets/booking_progress_timeline.dart';
import '../../widgets/booking_request_summary_card.dart';


class BookingStatusPage extends StatelessWidget {
  final String requestId;

  const BookingStatusPage({super.key, required this.requestId});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('bookingStatusPageTitle')),
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

                  
                  if (req != null && (req.status == BookingRequestStatus.approvedWaitingPayment || req.status == BookingRequestStatus.approved) && req.paymentDeadline != null) ...[
                    const SizedBox(height: 4),
                    _DeadlineCountdown(deadline: req.paymentDeadline!),
                    const SizedBox(height: 12),
                  ],

                  BookingProgressTimeline(status: req?.status),
                  const SizedBox(height: 14),
                  if (req != null) BookingRequestSummaryCard(request: req),
                  const SizedBox(height: 16),

                  Row(children: [Expanded(child: SizedBox(height: 52, child: ElevatedButton(
                    onPressed: () => context.read<BookingRequestBloc>().add(StatusRefreshRequested(requestId)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
                    child: Text(context.t('bookingStatusRefreshBtn')),
                  )))]),
                  const SizedBox(height: 12),

                  if (req != null && req.canCancelBeforeApproval) ...[
                    SizedBox(width: double.infinity, height: 52, child: OutlinedButton(
                      onPressed: () => context.read<BookingRequestBloc>().add(CancelRequestPressed(requestId)),
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)), side: const BorderSide(color: AppColors.inputBorder)),
                      child: Text(context.t('bookingStatusCancelBtn')),
                    )),
                    const SizedBox(height: 12),
                  ],

                  
                  if (req != null && (req.status == BookingRequestStatus.approvedWaitingPayment || req.status == BookingRequestStatus.approved)) ...[
                    SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).push(PaymentRoutes.payment(
                            bloc: AppInjector.createPaymentBloc(),
                            requestId: requestId,
                          ),),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
                      child: Text(context.t('bookingStatusGoPaymentBtn')),
                    )),
                    const SizedBox(height: 12),
                  ],

                  
                  if (req != null && req.status == BookingRequestStatus.paymentUnderReview) ...[
                    Container(padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFFE083))),
                      child: const Row(children: [Icon(Icons.hourglass_top, color: Color(0xFFB8860B)), SizedBox(width: 10), Expanded(child: Text('Payment submitted. Awaiting admin confirmation.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))])),
                    const SizedBox(height: 12),
                  ],

                  
                  if (req != null && (req.status == BookingRequestStatus.confirmed || req.status == BookingRequestStatus.paid)) ...[
                    Container(padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.approvedBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.approvedBorder)),
                      child: const Row(children: [Icon(Icons.check_circle, color: AppColors.approvedText), SizedBox(width: 10), Expanded(child: Text('Booking confirmed! See you there.', style: TextStyle(fontWeight: FontWeight.w600)))])),
                    const SizedBox(height: 12),
                  ],

                  
                  if (req != null && req.status == BookingRequestStatus.expired) ...[
                    Container(padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.danger)),
                      child: const Row(children: [Icon(Icons.timer_off, color: AppColors.danger), SizedBox(width: 10), Expanded(child: Text('Payment deadline expired. Booking was cancelled.', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.danger)))])),
                    const SizedBox(height: 12),
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
    final badge = _badgeFor(status, context);

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
              Expanded(
                child: Text(
                  context.t('bookingStatusHeader'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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
            request?.statusHint ?? context.t('bookingStatusPullRefresh'),
            style: TextStyle(color: AppColors.textDark, fontSize: 12),
          ),
        ],
      ),
    );
  }

  _Badge _badgeFor(BookingRequestStatus? status, BuildContext ctx) {
    switch (status) {
      case BookingRequestStatus.pending:
        return _Badge('Pending', AppColors.warningBg, AppColors.warningText);
      case BookingRequestStatus.underReview:
        return _Badge('Under Review', AppColors.reviewStatusBg, AppColors.reviewStatusText);
      case BookingRequestStatus.approvedWaitingPayment:
      case BookingRequestStatus.approved:
        return _Badge('Approved â€“ Pay Now', AppColors.approvedBg, AppColors.approvedText);
      case BookingRequestStatus.paymentUnderReview:
        return _Badge('Payment Review', const Color(0xFFFFF3CD), const Color(0xFFB8860B));
      case BookingRequestStatus.confirmed:
      case BookingRequestStatus.paid:
        return _Badge('Confirmed', AppColors.approvedBg, AppColors.approvedText);
      case BookingRequestStatus.rejected:
        return _Badge('Rejected', AppColors.rejectedBg, AppColors.danger);
      case BookingRequestStatus.cancelled:
        return _Badge('Cancelled', AppColors.neutralBadgeBg, AppColors.textDark);
      case BookingRequestStatus.expired:
        return _Badge('Expired', const Color(0xFFFFF0F0), AppColors.danger);
      default:
        return _Badge('Loading...', AppColors.neutralBadgeBg, AppColors.textDark);
    }
  }
}

class _Badge {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge(this.label, this.bg, this.fg);
}


class _DeadlineCountdown extends StatefulWidget {
  final DateTime deadline;
  const _DeadlineCountdown({required this.deadline});
  @override
  State<_DeadlineCountdown> createState() => _DeadlineCountdownState();
}

class _DeadlineCountdownState extends State<_DeadlineCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.deadline.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _remaining = widget.deadline.difference(DateTime.now()));
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isExpired = _remaining.isNegative;
    final h = _remaining.inHours.abs().toString().padLeft(2, '0');
    final m = (_remaining.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds.abs() % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isExpired ? const Color(0xFFFFF0F0) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isExpired ? AppColors.danger : AppColors.amber),
      ),
      child: Row(children: [
        Icon(isExpired ? Icons.timer_off : Icons.timer, color: isExpired ? AppColors.danger : AppColors.amber),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isExpired ? 'Payment deadline expired' : 'Pay within:',
            style: TextStyle(fontWeight: FontWeight.w700, color: isExpired ? AppColors.danger : Colors.black87, fontSize: 13)),
          if (!isExpired)
            Text('$h:$m:$s', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.black87)),
        ])),
      ]),
    );
  }
}

