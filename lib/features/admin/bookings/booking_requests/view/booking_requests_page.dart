import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../_shared/admin_feedback_widgets.dart';

import '../bloc/booking_requests_bloc.dart';
import '../bloc/booking_requests_event.dart';
import '../bloc/booking_requests_state.dart';
import '../data/repos/admin_bookings_repo_impl.dart';
import '../data/sources/admin_bookings_dummy_source.dart';
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
    final source = AdminBookingsDummySource();
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
            const AdminAppBar(title: 'Booking Requests', subtitle: 'Manage booking requests'),
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.black15, width: 1))),
              padding: const EdgeInsets.all(AdminSpace.s16),
              child: BlocBuilder<BookingRequestsBloc, BookingRequestsState>(
                buildWhen: (p, n) => p.activeTab != n.activeTab,
                builder: (context, state) {
                  return Row(
                    children: [
                      BookingTabButton(
                        label: 'Pending',
                        icon: AdminIconMapper.clock(),
                        activeIconColor: AdminColors.primaryAmber,
                        active: state.activeTab == BookingStatus.pending,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.pending)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: 'Approved',
                        icon: AdminIconMapper.checkCircle(),
                        activeIconColor: AdminColors.success,
                        active: state.activeTab == BookingStatus.approved,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.approved)),
                      ),
                      const SizedBox(width: AdminSpace.s8),
                      BookingTabButton(
                        label: 'Canceled',
                        icon: AdminIconMapper.xCircle(),
                        activeIconColor: AdminColors.danger,
                        active: state.activeTab == BookingStatus.canceled,
                        onTap: () => context.read<BookingRequestsBloc>().add(const BookingRequestsTabChanged(BookingStatus.canceled)),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AdminSpace.s16),
                child: BlocBuilder<BookingRequestsBloc, BookingRequestsState>(
                  builder: (context, state) {
                    if (state.status == BookingRequestsLoadStatus.loading && state.bookings.isEmpty) {
                      return const AdminListSkeleton(count: 5, height: 170);
                    }

                    if (state.bookings.isEmpty) {
                      return AdminEmptyState(
                        title: 'No bookings',
                        subtitle: 'There are no ${_tabLabel(state.activeTab)} requests right now.',
                        icon: AdminIconMapper.bookings(),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final b = state.bookings[i];
                        return BookingRequestCard(
                          booking: b,
                          onOpenDetails: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => BookingDetailsPage.withBloc(bookingId: b.id)),
                          ),
                          onAccept: (b.status == BookingStatus.pending) ? () => context.read<BookingRequestsBloc>().add(BookingRequestsAccepted(b.id)) : null,
                          onReject: (b.status == BookingStatus.pending) ? () => context.read<BookingRequestsBloc>().add(BookingRequestsRejected(b.id)) : null,
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
        BookingStatus.approved => 'approved',
        BookingStatus.canceled => 'canceled',
      };
}
