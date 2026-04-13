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
      onTrailingTap: () {},
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

        final upcoming = list.where((b) => b.status.toLowerCase() == 'upcoming').toList();
        final awaitingConfirmation = list.where((b) => b.status.toLowerCase() == 'awaiting_confirmation').toList();
        final confirmed = list.where((b) => b.status.toLowerCase() == 'confirmed').toList();
        final completed = list.where((b) => b.status.toLowerCase() == 'completed').toList();
        final cancelled = list.where((b) => b.status.toLowerCase() == 'cancelled').toList();

        final q = _search.text.trim().toLowerCase();

        List<BookingEntity> filter(List<BookingEntity> src) {
          if (q.isEmpty) return src;
          return src.where((b) => b.spaceName.toLowerCase().contains(q) || b.bookingId.toLowerCase().contains(q)).toList();
        }

        final tabData = [
          filter(upcoming),
          filter(awaitingConfirmation),
          filter(confirmed),
          filter(completed),
          filter(cancelled),
        ];

        final tabs = [
          context.t('upcomingBookings'),
          context.t('awaitingConfirmationTab'),
          context.t('confirmedBookingsTab'),
          context.t('pastBookings'),
          context.t('cancelledBookings'),
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
              ...currentList.map(
                (b) => BookingListItem(
                  booking: b,
                  onView: () => _openBookingDetails(context, b),
                  onCancel: _activeTabIndex <= 2
                      ? () => Navigator.of(context).push(
                            BookingRequestRoutes.bookingStatus(
                              bloc: AppInjector.createBookingBloc(),
                              bookingId: b.bookingId,
                              openCancelDialog: true,
                            ),
                          )
                      : null,
                  onRebook: _activeTabIndex == 3 ? () async => _rebookFromBooking(context, b) : null,
                ),
              ),
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
