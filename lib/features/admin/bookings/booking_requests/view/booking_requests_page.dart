import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../bloc/booking_requests_bloc.dart';
import '../bloc/booking_requests_event.dart';
import '../bloc/booking_requests_state.dart';
import '../data/repos/admin_bookings_repo_impl.dart';
import '../data/sources/admin_bookings_firebase_source.dart';
import '../domain/entities/booking_status.dart';
import '../domain/usecases/accept_booking_usecase.dart';
import '../domain/usecases/get_bookings_usecase.dart';
import '../domain/usecases/reject_booking_usecase.dart';
import '../widgets/booking_request_card.dart';
import '../widgets/booking_tab_button.dart';

import '../../booking_details/view/booking_details_page.dart';

class BookingRequestsPage extends StatelessWidget {
  const BookingRequestsPage({super.key});

  static Widget withBloc() {
    final source = AdminBookingsFirebaseSource();
    final repo = AdminBookingsRepoImpl(source);
    return BlocProvider(
      create: (_) => BookingRequestsBloc(
        getBookings: GetBookingsUseCase(repo),
        acceptBooking: AcceptBookingUseCase(repo),
        rejectBooking: RejectBookingUseCase(repo),
      )..add(const BookingRequestsStarted()),
      child: const BookingRequestsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminAppBar(title: context.t('adminBookingRequests'), subtitle: context.t('adminBookingRequestsSubtitle')),
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.black15, width: 1))),
              padding: const EdgeInsets.all(AdminSpace.s16),
              child: BlocBuilder<BookingRequestsBloc, BookingRequestsState>(
                buildWhen: (p, n) => p.activeTab != n.activeTab,
                builder: (context, state) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                      BookingTabButton(
                        label: context.t('adminTabPending'),
                        icon: AdminIconMapper.clock(),
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.pending,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.pending)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: context.t('adminTabAwaitingPayment'),
                        icon: AdminIconMapper.checkCircle(),
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.awaitingPayment,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.awaitingPayment)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: context.t('adminTabAwaitingConfirmation'),
                        icon: Icons.receipt_long_outlined,
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.awaitingConfirmation,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.awaitingConfirmation)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: context.t('adminTabBooked'),
                        icon: Icons.event_available_outlined,
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.booked,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.booked)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: context.t('adminTabCanceled'),
                        icon: AdminIconMapper.xCircle(),
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.canceled,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.canceled)),
                      ),
                    ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AdminSpace.s16),
                child: BlocBuilder<BookingRequestsBloc, BookingRequestsState>(
                  
                  buildWhen: (p, n) => p.activeTab != n.activeTab || p.bookings != n.bookings || p.status != n.status,
                  builder: (context, state) {
                    if (state.status == BookingRequestsLoadStatus.loading && state.bookings.isEmpty) {
                      return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
                    }
                    if (state.bookings.isEmpty) {
                      return Center(
                        child: Text(
                          'No ${_tabLabel(state.activeTab)} bookings',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AdminText.body16(color: AdminColors.black40),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AdminSpace.s12),
                      itemBuilder: (context, i) {
                        final b = state.bookings[i];
                        return BookingRequestCard(
                          booking: b,
                          onOpenDetails: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingDetailsPage.withBloc(bookingId: b.id)));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _tabLabel(BookingStatus s) => switch (s) {
        BookingStatus.pending => 'pending',
        BookingStatus.awaitingPayment => 'awaiting payment',
        BookingStatus.awaitingConfirmation => 'awaiting confirmation',
        BookingStatus.booked => 'booked',
        BookingStatus.canceled => 'canceled',
      };
}

extension on AdminSpace {
  static const s12 = 12.0;
}
