import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

import '../bloc/booking_details_bloc.dart';
import '../bloc/booking_details_event.dart';
import '../bloc/booking_details_state.dart';
import '../data/repos/admin_booking_details_repo_impl.dart';
import '../data/sources/admin_booking_details_firebase_source.dart';
import '../domain/usecases/cancel_booking_usecase.dart';
import '../domain/usecases/confirm_booking_usecase.dart';
import '../domain/usecases/get_booking_details_usecase.dart';
import '../widgets/kv_row.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  const BookingDetailsPage({super.key, required this.bookingId});

  static Widget withBloc({required String bookingId}) {
    final source = AdminBookingDetailsFirebaseSource();
    final repo = AdminBookingDetailsRepoImpl(source);

    return BlocProvider(
      create: (_) => BookingDetailsBloc(
        getDetails: GetBookingDetailsUseCase(repo),
        confirm: ConfirmBookingUseCase(repo),
        cancel: CancelBookingUseCase(repo),
      )..add(BookingDetailsStarted(bookingId)),
      child: BookingDetailsPage(bookingId: bookingId),
    );
  }

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _openCancelSheet(BuildContext context) async {
    _reason.text = '';
    final reasons = _localizedReasons(context);
    String selected = reasons.first;
    String customReason = '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdminColors.bg,
      barrierColor: const Color(0x66000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: AdminRadii.r24),
      ),
      builder: (ctx) {
        final inset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('adminCancelBooking'), style: AdminText.h2()),
                    const SizedBox(height: 16),
                    Text(context.t('adminCancelReason'), style: AdminText.body14(color: AdminColors.black75)),
                    const SizedBox(height: 16),
                    StatefulBuilder(
                      builder: (ctx2, setInner) {
                        final bookingStatus = context.read<BookingDetailsBloc>().state.details?.status ?? '';
                        final noteRequired = bookingStatus == 'payment_under_review' ||
                            bookingStatus == 'confirmed' ||
                            bookingStatus == 'paid';
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: selected,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AdminColors.black15, width: 1),
                                ),
                              ),
                              items: reasons
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AdminText.body14())))
                                  .toList(),
                              onChanged: (v) => setInner(() => selected = v ?? reasons.first),
                            ),
                            if (selected == context.t('cancelReasonOther')) ...[
                              const SizedBox(height: 10),
                              TextField(
                                maxLines: 2,
                                onChanged: (v) => customReason = v.trim(),
                                decoration: InputDecoration(
                                  hintText: context.t('cancelReasonAddNew'),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            TextField(
                              controller: _reason,
                              maxLines: 3,
                              style: AdminText.body16(),
                              decoration: InputDecoration(
                                hintText: noteRequired
                                    ? context.t('cancelDescriptionRequired')
                                    : context.t('cancelDescriptionOptional'),
                                hintStyle: AdminText.body16(color: AdminColors.black40),
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AdminColors.black15, width: 1),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AdminButton.outline(
                            label: context.t('adminBack'),
                            onTap: () => Navigator.of(ctx).pop(),
                            bg: AdminColors.black15,
                            fg: AdminColors.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminButton.filled(
                            label: context.t('adminConfirmCancel'),
                            onTap: () {
                              final bookingStatus = context.read<BookingDetailsBloc>().state.details?.status ?? '';
                              final noteRequired = bookingStatus == 'payment_under_review' ||
                                  bookingStatus == 'confirmed' ||
                                  bookingStatus == 'paid';
                              final note = _reason.text.trim();
                              final reason = selected == context.t('cancelReasonOther')
                                  ? (customReason.isEmpty ? context.t('cancelReasonOther') : customReason)
                                  : selected;
                              if (noteRequired && note.isEmpty) return;
                              Navigator.of(ctx).pop();
                              context.read<BookingDetailsBloc>().add(
                                    BookingDetailsCanceled(
                                      widget.bookingId,
                                      note.isEmpty ? reason : '$reason — $note',
                                    ),
                                  );
                              Navigator.of(context).maybePop();
                            },
                            bg: AdminColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
          builder: (context, state) {
            if (state.status == BookingDetailsStatus.loading || state.details == null) {
              return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
            }

            final b = state.details!;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: context.t('adminBookingDetails'),
                        subtitle: 'ID: ${b.bookingCode}',
                        onBack: () => Navigator.of(context).maybePop(),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(context.t('adminCustomerInfo'), style: AdminText.h2()),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: const BoxDecoration(color: AdminColors.primaryBlue, shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: Text(b.userAvatar, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(color: Colors.white, w: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(b.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        AdminTag(text: _statusText(b.status), tint: AdminColors.primaryAmber.withOpacity(0.15), textColor: AdminColors.primaryAmber),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(AdminIconMapper.phone(), size: 18, color: AdminColors.primaryBlue),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(b.userPhone, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(AdminIconMapper.mail(), size: 18, color: AdminColors.primaryBlue),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(b.userEmail, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(context.t('adminBookingInfo'), style: AdminText.h2()),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AdminColors.black15, width: 1),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: const BoxDecoration(
                                  color: AdminColors.black02,
                                  border: Border(bottom: BorderSide(color: AdminColors.black10, width: 1)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(context.t('adminField'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(context.t('adminDetailsCol'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
                                  ],
                                ),
                              ),
                              KvRow(label: context.t('adminKvSpace'), value: b.space, last: false),
                              KvRow(label: context.t('adminKvAddress'), value: b.spaceAddress, last: false),
                              KvRow(label: context.t('adminKvDate'), value: b.date, last: false),
                              KvRow(label: context.t('adminKvTime'), value: b.time, last: false),
                              KvRow(label: context.t('adminKvDuration'), value: b.duration, last: false),
                              KvRow(label: context.t('adminKvPlan'), value: b.plan, last: false),
                              KvRow(label: context.t('adminKvPrice'), value: b.price, last: false),
                              KvRow(label: context.t('adminKvTotal'), value: b.total, last: true),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      if (b.paymentMethod != '-' || b.paymentReceiptUrl.isNotEmpty || b.payerReferenceNumber.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Payment Information', style: AdminText.h2()),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AdminCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KvRow(label: 'Payment status', value: b.paymentStatus, last: false),
                                KvRow(label: 'Method', value: b.paymentMethod, last: false),
                                KvRow(label: 'Account name', value: b.payerAccountHolder.isEmpty ? '-' : b.payerAccountHolder, last: false),
                                KvRow(label: 'Transfer time', value: b.payerTransferTime.isEmpty ? '-' : b.payerTransferTime, last: false),
                                KvRow(label: 'Reference #', value: b.payerReferenceNumber.isEmpty ? '-' : b.payerReferenceNumber, last: b.paymentReceiptUrl.isEmpty),
                                if (b.paymentReceiptUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(b.paymentReceiptUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (b.cancelReason.isNotEmpty ||
                          b.cancellationStage.isNotEmpty ||
                          b.cancelledBy.isNotEmpty ||
                          b.cancelledAt.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(context.t('cancelInfoTitle'), style: AdminText.h2()),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AdminCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KvRow(label: context.t('cancelledByLabel'), value: b.cancelledBy.isEmpty ? '-' : b.cancelledBy, last: false),
                                KvRow(label: context.t('cancelReasonLabel'), value: b.cancelReason.isEmpty ? '-' : b.cancelReason, last: false),
                                KvRow(label: context.t('cancelledAtLabel'), value: b.cancelledAt.isEmpty ? '-' : b.cancelledAt, last: false),
                                KvRow(label: context.t('cancellationStageLabel'), value: b.cancellationStage.isEmpty ? '-' : b.cancellationStage, last: true),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Column(
                          children: [
                            if (b.status == 'pending' || b.status == 'under_review')
                              AdminButton.filled(
                                label: 'Approve Booking',
                                onTap: () {
                                  context.read<BookingDetailsBloc>().add(BookingDetailsConfirmed(widget.bookingId));
                                  Navigator.of(context).maybePop();
                                },
                                bg: AdminColors.success,
                              ),
                            if (b.status == 'payment_under_review') ...[
                              const SizedBox(height: 8),
                              AdminButton.filled(
                                label: 'Confirm Booking',
                                onTap: () {
                                  context.read<BookingDetailsBloc>().add(BookingDetailsConfirmed(widget.bookingId));
                                  Navigator.of(context).maybePop();
                                },
                                bg: AdminColors.primaryBlue,
                              ),
                            ],
                            const SizedBox(height: 12),
                            AdminButton.outline(
                              label: context.t('adminCancelBooking'),
                              onTap: () => _openCancelSheet(context),
                              bg: AdminColors.danger,
                              fg: AdminColors.danger,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'approved_waiting_payment':
        return 'Awaiting payment';
      case 'payment_under_review':
        return 'Payment under review';
      case 'confirmed':
      case 'paid':
        return 'Booked';
      case 'canceled':
      case 'rejected':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  List<String> _localizedReasons(BuildContext context) {
    return [
      context.t('cancelReasonNoAvailability'),
      context.t('cancelReasonMaintenance'),
      context.t('cancelReasonPolicyIssue'),
      context.t('cancelReasonPricingConflict'),
      context.t('cancelReasonDuplicate'),
      context.t('cancelReasonClosed'),
      context.t('cancelReasonEmergency'),
      context.t('cancelReasonInsufficientDetails'),
      context.t('cancelReasonPaymentIssue'),
      context.t('cancelReasonSecurity'),
      context.t('cancelReasonTimeNotSuitable'),
      context.t('cancelReasonOther'),
    ];
  }
}
