import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/booking_details_bloc.dart';
import '../bloc/booking_details_event.dart';
import '../bloc/booking_details_state.dart';
import '../data/repos/admin_booking_details_repo_impl.dart';
import '../data/sources/admin_booking_details_dummy_source.dart';
import '../domain/usecases/cancel_booking_usecase.dart';
import '../domain/usecases/confirm_booking_usecase.dart';
import '../domain/usecases/get_booking_details_usecase.dart';
import '../widgets/kv_row.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  const BookingDetailsPage({super.key, required this.bookingId});

  static Widget withBloc({required String bookingId}) {
    final source = AdminBookingDetailsDummySource();
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
                    Text('Cancel Booking', style: AdminText.h2()),
                    const SizedBox(height: 16),
                    Text('Please provide a reason for cancellation', style: AdminText.body14(color: AdminColors.black75)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reason,
                      maxLines: 4,
                      style: AdminText.body16(),
                      decoration: InputDecoration(
                        hintText: 'Enter cancellation reason...',
                        hintStyle: AdminText.body16(color: AdminColors.black40),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AdminColors.black15, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AdminColors.black15, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AdminColors.black15, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AdminButton.outline(
                            label: 'Back',
                            onTap: () => Navigator.of(ctx).pop(),
                            bg: AdminColors.black15,
                            fg: AdminColors.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminButton.filled(
                            label: 'Confirm Cancel',
                            onTap: () {
                              final r = _reason.text.trim();
                              if (r.isEmpty) return;
                              Navigator.of(ctx).pop();
                              context.read<BookingDetailsBloc>().add(BookingDetailsCanceled(widget.bookingId, r));
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
                        title: 'Booking Details',
                        subtitle: 'ID: ${b.bookingCode}',
                        onBack: () => Navigator.of(context).maybePop(),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Customer Information', style: AdminText.h2()),
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
                                        AdminTag(text: 'Pending', tint: AdminColors.primaryAmber.withOpacity(0.15), textColor: AdminColors.primaryAmber),
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
                        child: Text('Booking Information', style: AdminText.h2()),
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
                                    Expanded(child: Text('Field', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text('Details', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
                                  ],
                                ),
                              ),
                              KvRow(label: 'Space', value: b.space, last: false),
                              KvRow(label: 'Address', value: b.spaceAddress, last: false),
                              KvRow(label: 'Date', value: b.date, last: false),
                              KvRow(label: 'Time', value: b.time, last: false),
                              KvRow(label: 'Duration', value: b.duration, last: false),
                              KvRow(label: 'Plan', value: b.plan, last: false),
                              KvRow(label: 'Price', value: b.price, last: false),
                              KvRow(label: 'Total', value: b.total, last: true),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Column(
                          children: [
                            AdminButton.filled(
                              label: 'Confirm Booking',
                              onTap: () {
                                context.read<BookingDetailsBloc>().add(BookingDetailsConfirmed(widget.bookingId));
                                Navigator.of(context).maybePop();
                              },
                              bg: AdminColors.success,
                            ),
                            const SizedBox(height: 12),
                            AdminButton.outline(
                              label: 'Cancel Booking',
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
}
