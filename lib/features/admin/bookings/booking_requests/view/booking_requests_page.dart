import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/app_injector.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../../../../../core/widgets/app_tabs.dart';
import '../bloc/booking_requests_bloc.dart';
import '../bloc/booking_requests_event.dart';
import '../bloc/booking_requests_state.dart';
import '../domain/entities/booking_status.dart';
import '../widgets/booking_request_card.dart';

import '../../booking_details/view/booking_details_page.dart';

class BookingRequestsPage extends StatelessWidget {
  const BookingRequestsPage({super.key});

  static const _tabs = [
    BookingStatus.all,
    BookingStatus.pending,
    BookingStatus.awaitingPayment,
    BookingStatus.awaitingConfirmation,
    BookingStatus.booked,
    BookingStatus.canceled,
  ];

  static Widget withBloc() {
    return BlocProvider(
      create: (_) =>
          AppInjector.createAdminBookingRequestsBloc()
            ..add(const BookingRequestsStarted()),
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
                  final labels = [
                    context.t('bookingsTabAll'),
                    context.t('adminTabPending'),
                    context.t('adminTabAwaitingPayment'),
                    context.t('adminTabAwaitingConfirmation'),
                    context.t('adminTabBooked'),
                    context.t('adminTabCanceled'),
                  ];
                  final selectedIndex = _tabs.indexOf(state.activeTab);
                  return AppTabs(
                    labels: labels,
                    selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                    onChanged: (i) => context
                        .read<BookingRequestsBloc>()
                        .add(BookingRequestsTabChanged(_tabs[i])),
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
        BookingStatus.all => 'all',
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
