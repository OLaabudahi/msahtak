import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../core/i18n/app_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_injector.dart';
import '../../../../../services/auth_service.dart';
import '../../../../payments_receipts/domain/entities/user_receipt_entity.dart';
import '../../../../payments_receipts/view/invoice_page.dart';
import '../../../payment/view/payment_routes.dart';
import '../../bloc/booking_request_bloc.dart';
import '../../bloc/booking_request_event.dart';
import '../../bloc/booking_request_state.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../widgets/booking_progress_timeline.dart';
import '../../widgets/booking_request_summary_card.dart';
import 'report_issue_page.dart';

class BookingStatusPage extends StatefulWidget {
  final String bookingId;
  final bool openCancelDialogOnLoad;

  const BookingStatusPage({
    super.key,
    required this.bookingId,
    this.openCancelDialogOnLoad = false,
  });

  @override
  State<BookingStatusPage> createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  bool _cancelDialogOpened = false;
  late final AuthService _authService;

  static const _pagePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  @override
  void initState() {
    super.initState();
    _authService = getIt<AuthService>();
  }

  DateTime _resolveEndDate(BookingRequestEntity req) {
    switch (req.durationUnit) {
      case DurationUnit.days:
        return req.startDate.add(Duration(days: req.durationValue));
      case DurationUnit.weeks:
        return req.startDate.add(Duration(days: req.durationValue * 7));
      case DurationUnit.months:
        return req.startDate.add(Duration(days: req.durationValue * 30));
    }
  }

  bool _isOwnerCancellationAfterPayment(BookingRequestEntity? request) {
    if (request == null) return false;
    final cancelledBy = (request.cancelledBy ?? '').toLowerCase();
    final cancelledByOwner = cancelledBy.contains('owner') ||
        cancelledBy.contains('space_owner') ||
        cancelledBy.contains('admin') ||
        cancelledBy.contains('sub_admin') ||
        cancelledBy.contains('sup_admin');
    if (!cancelledByOwner) return false;
    final stage = (request.cancellationStage ?? '').toLowerCase();
    if (stage == 'after_payment') return true;
    return (request.paymentReceiptUrl ?? '').trim().isNotEmpty;
  }

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
            if (state.uiStatus == BookingRequestUiStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (!_cancelDialogOpened &&
                widget.openCancelDialogOnLoad &&
                state.createdRequest != null) {
              final req = state.createdRequest!;
              final canOpen = req.canCancelBeforeApproval ||
                  req.status == BookingRequestStatus.approvedWaitingPayment ||
                  req.status == BookingRequestStatus.approved ||
                  req.status == BookingRequestStatus.paymentUnderReview ||
                  req.status == BookingRequestStatus.confirmed ||
                  req.status == BookingRequestStatus.paid;
              if (canOpen) {
                _cancelDialogOpened = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _showCancelDialog(context, req);
                });
              }
            }
          },
          builder: (context, state) {
            final req = state.createdRequest;
            final isBusy = state.uiStatus == BookingRequestUiStatus.loading;
            final showComplaintInsteadOfRefresh =
                _isOwnerCancellationAfterPayment(req);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookingRequestBloc>().add(
                  StatusRefreshRequested(widget.bookingId),
                );
              },
              child: ListView(
                padding: _pagePadding,
                children: [
                  if (isBusy) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 10),
                  _StatusHeaderCard(request: req),
                  const SizedBox(height: 14),

                  if (req != null &&
                      (req.status ==
                              BookingRequestStatus.approvedWaitingPayment ||
                          req.status == BookingRequestStatus.approved) &&
                      req.paymentDeadline != null) ...[
                    const SizedBox(height: 4),
                    _DeadlineCountdown(deadline: req.paymentDeadline!),
                    const SizedBox(height: 12),
                  ],

                  BookingProgressTimeline(status: req?.status),
                  const SizedBox(height: 14),
                  if (req != null) BookingRequestSummaryCard(request: req),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: showComplaintInsteadOfRefresh
                              ? OutlinedButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ReportIssuePage(
                                        bookingId: req!.bookingId,
                                        spaceName: req.space.name,
                                        bookingStatus: req.status,
                                      ),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.danger,
                                    ),
                                  ),
                                  icon: const Icon(Icons.report_problem_outlined),
                                  label: Text(context.t('submitComplaint')),
                                )
                              : ElevatedButton(
                                  onPressed: () => context
                                      .read<BookingRequestBloc>()
                                      .add(StatusRefreshRequested(widget.bookingId)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  child: Text(context.t('bookingStatusRefreshBtn')),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (req != null &&
                      (req.canCancelBeforeApproval ||
                          req.status == BookingRequestStatus.approvedWaitingPayment ||
                          req.status == BookingRequestStatus.approved ||
                          req.status == BookingRequestStatus.paymentUnderReview ||
                          req.status == BookingRequestStatus.confirmed ||
                          req.status == BookingRequestStatus.paid)) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => _showCancelDialog(context, req),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          side: const BorderSide(color: AppColors.inputBorder),
                        ),
                        child: Text(context.t('bookingStatusCancelBtn')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      (req.status ==
                              BookingRequestStatus.approvedWaitingPayment ||
                          req.status == BookingRequestStatus.approved)) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          PaymentRoutes.payment(
                            bloc: AppInjector.createPaymentBloc(),
                            bookingId: widget.bookingId,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(context.t('bookingStatusGoPaymentBtn')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      req.status ==
                          BookingRequestStatus.paymentUnderReview) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFE083)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_top, color: Color(0xFFB8860B)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('paymentSubmitted'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      req.status == BookingRequestStatus.paymentRejected) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.danger),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.danger),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  context.t('paymentRejectedMessage'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showIssueReportHint(context),
                              icon: const Icon(Icons.report_problem_outlined),
                              label: Text(context.t('reportIssue')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      (req.status == BookingRequestStatus.confirmed ||
                          req.status == BookingRequestStatus.paid)) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.approvedBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.approvedBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.approvedText,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('bookingConfirmed'),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final invoice = UserReceiptEntity(
                            bookingId: req.bookingId,
                            spaceName: req.space.name,
                            userName: (_authService.currentUser?.displayName ?? '').trim(),
                            userEmail: (_authService.currentUser?.email ?? '').trim(),
                            startDate: req.startDate,
                            endDate: _resolveEndDate(req),
                            paymentMethod: 'unknown',
                            totalPrice: req.totalAmount.toDouble(),
                            currency: req.currency,
                            status: req.status.name,
                            createdAt: req.createdAt ?? DateTime.now(),
                          );
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InvoicePage.withBloc(invoice),
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long_outlined),
                        label: Text(context.t('invoice')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],


                  if (req != null && req.status == BookingRequestStatus.active) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF71C99A)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.play_circle_fill, color: Color(0xFF2A8B57)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('bookingActiveMessage'),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null && req.status == BookingRequestStatus.completed) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF9BB2FF)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.task_alt, color: Color(0xFF3558C5)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('bookingCompletedMessage'),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      req.status == BookingRequestStatus.expired) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.danger),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_off, color: AppColors.danger),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('paymentExpired'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (req != null &&
                      (req.status == BookingRequestStatus.cancelled ||
                          req.status == BookingRequestStatus.rejected)) ...[
                    _CancellationInfoCard(
                      request: req,
                      canSubmitComplaint: showComplaintInsteadOfRefresh,
                    ),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cancelDialogOpened || !widget.openCancelDialogOnLoad) return;
    final req = context.read<BookingRequestBloc>().state.createdRequest;
    if (req == null) return;
    final canOpen = req.canCancelBeforeApproval ||
        req.status == BookingRequestStatus.approvedWaitingPayment ||
        req.status == BookingRequestStatus.approved ||
        req.status == BookingRequestStatus.paymentUnderReview ||
        req.status == BookingRequestStatus.confirmed ||
        req.status == BookingRequestStatus.paid;
    if (!canOpen) return;
    _cancelDialogOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showCancelDialog(context, req);
    });
  }

  Future<void> _showCancelDialog(BuildContext context, BookingRequestEntity req) async {
    final noteCtrl = TextEditingController();
    final customCtrl = TextEditingController();
    final reasons = _cancelReasonsLocalized(context);
    String selected = reasons.first;
    final afterPayment = req.status == BookingRequestStatus.paymentUnderReview ||
        req.status == BookingRequestStatus.confirmed ||
        req.status == BookingRequestStatus.paid;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setState) {
            return AlertDialog(
              title: Text(context.t('bookingStatusCancelBtn')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selected,
                      items: reasons
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => selected = v ?? reasons.first),
                    ),
                    if (selected == context.t('cancelReasonOther')) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: customCtrl,
                        decoration: InputDecoration(hintText: context.t('cancelReasonAddNew')),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: afterPayment
                            ? context.t('cancelDescriptionRequired')
                            : context.t('cancelDescriptionOptional'),
                      ),
                    ),
                    if (afterPayment) ...[
                      const SizedBox(height: 10),
                      Text(
                        context.t('cancelFeeWarning'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                if (afterPayment)
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx2).pop();
                      _showIssueReportHint(context);
                    },
                    child: Text(context.t('reportIssue')),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(ctx2).pop(),
                  child: Text(context.t('cancel')),
                ),
                ElevatedButton(
                  onPressed: () {
                    final note = noteCtrl.text.trim();
                    if (afterPayment && note.isEmpty) return;
                    final reason = selected == context.t('cancelReasonOther')
                        ? (customCtrl.text.trim().isEmpty ? context.t('cancelReasonOther') : customCtrl.text.trim())
                        : selected;
                    context.read<BookingRequestBloc>().add(
                          CancelRequestPressed(
                            widget.bookingId,
                            reason: note.isEmpty ? reason : '$reason — $note',
                          ),
                        );
                    Navigator.of(ctx2).pop();
                  },
                  child: Text(context.t('confirm')),
                ),
              ],
            );
          },
        );
      },
    );
    noteCtrl.dispose();
    customCtrl.dispose();
  }

  List<String> _cancelReasonsLocalized(BuildContext context) {
    return [
      context.t('cancelReasonPlanChanged'),
      context.t('cancelReasonFoundOther'),
      context.t('cancelReasonHighPrice'),
      context.t('cancelReasonPaymentIssue'),
      context.t('cancelReasonTimeNotSuitable'),
      context.t('cancelReasonDetailsWrong'),
      context.t('cancelReasonDifferentLocation'),
      context.t('cancelReasonMoreSeats'),
      context.t('cancelReasonFewerSeats'),
      context.t('cancelReasonEmergency'),
      context.t('cancelReasonPolicyIssue'),
      context.t('cancelReasonOther'),
    ];
  }
}

class _CancellationInfoCard extends StatelessWidget {
  final BookingRequestEntity request;
  final bool canSubmitComplaint;

  const _CancellationInfoCard({
    required this.request,
    required this.canSubmitComplaint,
  });

  @override
  Widget build(BuildContext context) {
    final cancelledAt = request.cancelledAt;
    String cancelledAtText = '-';
    if (cancelledAt != null) {
      final mm = cancelledAt.month.toString().padLeft(2, '0');
      final dd = cancelledAt.day.toString().padLeft(2, '0');
      final hh = cancelledAt.hour.toString().padLeft(2, '0');
      final mi = cancelledAt.minute.toString().padLeft(2, '0');
      cancelledAtText = '$dd/$mm/${cancelledAt.year} $hh:$mi';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t('cancelInfoTitle'),
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.danger)),
          const SizedBox(height: 8),
          Text('${context.t('cancelledByLabel')}: ${request.cancelledBy ?? '-'}'),
          Text('${context.t('cancelReasonLabel')}: ${request.cancelReason ?? '-'}'),
          Text('${context.t('cancelledAtLabel')}: $cancelledAtText'),
          Text('${context.t('cancellationStageLabel')}: ${request.cancellationStage ?? '-'}'),
          if (canSubmitComplaint) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReportIssuePage(
                      bookingId: request.bookingId,
                      spaceName: request.space.name,
                      bookingStatus: request.status,
                    ),
                  ),
                ),
                icon: const Icon(Icons.report_problem_outlined),
                label: Text(context.t('submitComplaint')),
              ),
            ),
          ],
        ],
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badge.bg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(
                    color: badge.fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
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

  _Badge _badgeFor(BookingRequestStatus? status, BuildContext context) {
    switch (status) {
      case BookingRequestStatus.pending:
        return _Badge(
          context.t('pending'),
          AppColors.warningBg,
          AppColors.warningText,
        );
      case BookingRequestStatus.underReview:
        return _Badge(
          context.t('underReview'),
          AppColors.reviewStatusBg,
          AppColors.reviewStatusText,
        );
      case BookingRequestStatus.approvedWaitingPayment:
      case BookingRequestStatus.approved:
        return _Badge(
          context.t('approvedPay'),
          AppColors.approvedBg,
          AppColors.approvedText,
        );
      case BookingRequestStatus.paymentUnderReview:
        return _Badge(
          context.t('paymentReview'),
          const Color(0xFFFFF3CD),
          const Color(0xFFB8860B),
        );
      case BookingRequestStatus.confirmed:
      case BookingRequestStatus.paid:
        return _Badge(
          context.t('confirmed'),
          AppColors.approvedBg,
          AppColors.approvedText,
        );
      case BookingRequestStatus.paymentRejected:
        return _Badge(
          context.t('paymentRejectedLabel'),
          const Color(0xFFFFF0F0),
          AppColors.danger,
        );
      case BookingRequestStatus.active:
        return _Badge(
          context.t('activeStatusLabel'),
          const Color(0xFFE9F7EF),
          const Color(0xFF2A8B57),
        );
      case BookingRequestStatus.completed:
        return _Badge(
          context.t('completedStatusLabel'),
          const Color(0xFFEFF3FF),
          const Color(0xFF3558C5),
        );
      case BookingRequestStatus.rejected:
        return _Badge(
          context.t('rejected'),
          AppColors.rejectedBg,
          AppColors.danger,
        );
      case BookingRequestStatus.cancelled:
        return _Badge(
          context.t('cancelled'),
          AppColors.neutralBadgeBg,
          AppColors.textDark,
        );
      case BookingRequestStatus.expired:
        return _Badge(
          context.t('expired'),
          const Color(0xFFFFF0F0),
          AppColors.danger,
        );
      default:
        return _Badge(
          context.t('loading'),
          AppColors.neutralBadgeBg,
          AppColors.textDark,
        );
    }
  }
}

void _showIssueReportHint(BuildContext context) {
  final req = context.read<BookingRequestBloc>().state.createdRequest;
  if (req == null) return;

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ReportIssuePage(
        bookingId: req.bookingId,
        spaceName: req.space.name,
        bookingStatus: req.status,
      ),
    ),
  );
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
      if (mounted) {
        setState(() => _remaining = widget.deadline.difference(DateTime.now()));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
        border: Border.all(
          color: isExpired ? AppColors.danger : AppColors.amber,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            color: isExpired ? AppColors.danger : AppColors.amber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpired ? context.t('paymentDeadlineExpired') : context.t('payWithin'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isExpired ? AppColors.danger : Colors.black87,
                    fontSize: 13,
                  ),
                ),
                if (!isExpired)
                  Text(
                    '$h:$m:$s',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
