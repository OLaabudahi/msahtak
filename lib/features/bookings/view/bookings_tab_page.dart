import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/app_injector.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../core/widgets/app_tabs.dart';
import '../../../core/ui/widgets/app_search_bar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../booking_request/bloc/booking_request_event.dart';
import '../../booking_request/domain/entities/booking_request_entity.dart';
import '../../booking_request/view/booking_request_routes.dart';
import '../../ai_concierge/view/ai_concierge_page.dart';
import '../bloc/bookings_bloc.dart';
import '../bloc/bookings_event.dart';
import '../bloc/bookings_state.dart';
import '../domain/entities/booking_entity.dart';
import '../domain/usecases/get_booking_by_id_usecase.dart';
import '../widgets/booking_list_item.dart';

class BookingsTabPage extends StatefulWidget {
  const BookingsTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => getIt<BookingsBloc>()..add(const BookingsStarted()),
      child: const BookingsTabPage(),
    );
  }

  @override
  State<BookingsTabPage> createState() => _BookingsTabPageState();
}

class _BookingsTabPageState extends State<BookingsTabPage> {
  final _search = TextEditingController();
  int _activeTabIndex = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openBookingDetails(BuildContext context, BookingEntity booking) {
    Navigator.of(context).push(
      BookingRequestRoutes.bookingStatus(
        bloc: AppInjector.createBookingBloc(),
        bookingId: booking.bookingId,
      ),
    );
  }

  DateTime _parseDate(String value) {
    final raw = value.contains(' ') ? value.split(' ').last : value;
    final parts = raw.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return DateTime.now();
  }

  Future<void> _rebookFromBooking(BuildContext context, BookingEntity booking) async {
    final bookingModel = await getIt<GetBookingByIdUseCase>().call(booking.bookingId);

    final space = SpaceSummaryEntity(
      id: booking.spaceId,
      name: bookingModel?.spaceName ?? booking.spaceName,
      basePricePerDay: (bookingModel?.totalPrice ?? booking.totalPrice).toInt(),
      currency: bookingModel?.currency ?? booking.currency,
    );

    final bookingBloc = AppInjector.createBookingBloc();

    if (!context.mounted) return;
    Navigator.of(context).push(
      BookingRequestRoutes.requestBooking(
        bloc: bookingBloc,
        space: space,
      ),
    );

    Future.microtask(() {
      bookingBloc
        ..add(StartDateChanged(_parseDate(bookingModel?.dateText ?? booking.dateText)))
        ..add(const DurationUnitChanged(DurationUnit.days))
        ..add(const DurationValueChanged(1));
    });
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _searchBar(String hintText, String aiLabel) {
    return AppSearchBar(
      controller: _search,
      hintText: hintText,
      onChanged: (_) => setState(() {}),
      trailingLabel: aiLabel,
      onTrailingTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AiConciergePage.withBloc())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        final bloc = context.read<BookingsBloc>();

        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('${context.t('bookingLoadErrorPrefix')} ${state.error}'));
        }

        final list = state.bookings;

        final q = _search.text.trim().toLowerCase();

        List<BookingEntity> filter(List<BookingEntity> src) {
          if (q.isEmpty) return src;
          return src
              .where((b) =>
                  b.spaceName.toLowerCase().contains(q) ||
                  b.bookingId.toLowerCase().contains(q))
              .toList(growable: false);
        }

        final all = filter(list);
        final now = DateTime.now();
        final active = filter(
          list.where((b) {
            final start = b.startAt;
            final end = b.endAt;
            if (start == null || end == null) return false;

            final raw = b.rawStatus.toLowerCase();
            final hasAcceptedStatus = raw == 'approved' ||
                raw == 'approved_waiting_payment' ||
                raw == 'confirmed' ||
                raw == 'paid' ||
                raw == 'active';
            if (!hasAcceptedStatus) return false;

            return (now.isAtSameMomentAs(start) || now.isAfter(start)) &&
                now.isBefore(end);
          }).toList(growable: false),
        );
        final confirmed = filter(list
            .where((b) => b.status.toLowerCase() == 'confirmed')
            .toList(growable: false));
        final awaitingPayment = filter(list
            .where((b) => b.rawStatus.toLowerCase() == 'approved_waiting_payment')
            .toList(growable: false));
        final awaitingAcceptance = filter(list
            .where((b) =>
                b.rawStatus.toLowerCase() == 'pending' ||
                b.rawStatus.toLowerCase() == 'under_review' ||
                b.rawStatus.toLowerCase() == 'payment_under_review')
            .toList(growable: false));
        final cancelled = filter(list
            .where((b) => b.status.toLowerCase() == 'cancelled')
            .toList(growable: false));
        final past = filter(list
            .where((b) => b.status.toLowerCase() == 'completed')
            .toList(growable: false));

        final tabData = [
          all,
          active,
          confirmed,
          awaitingPayment,
          awaitingAcceptance,
          cancelled,
          past,
        ];

        final tabs = [
          context.t('bookingsTabAll'),
          context.t('bookingsTabActive'),
          context.t('bookingsTabConfirmed'),
          context.t('bookingsTabAwaitingPayment'),
          context.t('bookingsTabAwaitingAcceptance'),
          context.t('cancelledBookings'),
          context.t('pastBookings'),
        ];

        final currentList = tabData[_activeTabIndex];
        return RefreshIndicator(
          onRefresh: () async => bloc.add(const BookingsRefreshRequested()),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              const SizedBox(height: 6),
              Text(context.t('navBookings'), style: AppTextStyles.sectionBarTitle),
              const SizedBox(height: 14),
              _searchBar(context.t('searchHint'), context.t('aiConcierge')),
              const SizedBox(height: 14),
              AppTabs(
                labels: tabs,
                selectedIndex: _activeTabIndex,
                onChanged: (i) => setState(() => _activeTabIndex = i),
              ),
              const SizedBox(height: 8),
              _sectionTitle(tabs[_activeTabIndex]),
              ...currentList.map((b) {
                final canCancel = _activeTabIndex <= 4;
                final canRebook = _activeTabIndex == 6;
                final statusTitle = b.rawStatus.isEmpty ? b.status : b.rawStatus;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_activeTabIndex == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 6),
                        child: Text(
                          '${context.t('bookingTypePrefix')}: $statusTitle',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    BookingListItem(
                      booking: b,
                      onView: () => _openBookingDetails(context, b),
                      onCancel: canCancel
                          ? () => Navigator.of(context).push(
                                BookingRequestRoutes.bookingStatus(
                                  bloc: AppInjector.createBookingBloc(),
                                  bookingId: b.bookingId,
                                  openCancelDialog: true,
                                ),
                              )
                          : null,
                      onRebook: canRebook ? () async => _rebookFromBooking(context, b) : null,
                    ),
                  ],
                );
              }),
              if (currentList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: Text(context.t('noBookingsYet'))),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
