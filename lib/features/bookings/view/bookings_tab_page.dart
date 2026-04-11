import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/app_injector.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_text_styles.dart';

import '../bloc/bookings_bloc.dart';
import '../bloc/bookings_event.dart';
import '../bloc/bookings_state.dart';

import '../domain/entities/booking_entity.dart';
import '../domain/usecases/get_bookings_usecase.dart';
import '../domain/usecases/cancel_booking_usecase.dart';

import '../data/repos/bookings_repo_impl.dart';
import '../data/sources/bookings_firebase_source.dart';
import '../../../core/services/firestore_api.dart';

import '../widgets/booking_list_item.dart';
import '../../booking_request/bloc/booking_request_event.dart';
import '../../booking_request/domain/entities/booking_request_entity.dart';
import '../../booking_request/view/booking_request_routes.dart';

class BookingsTabPage extends StatefulWidget {
  const BookingsTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => BookingsBloc(
        getBookings: GetBookingsUseCase(
          BookingsRepoImpl(
            BookingsFirebaseSource(FirestoreApi()),
          ),
        ),
        cancelBooking: CancelBookingUseCase(
          BookingsRepoImpl(
            BookingsFirebaseSource(FirestoreApi()),
          ),
        ),
      )..add(const BookingsStarted()),
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
    final parts = value.split('/');
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
    final bookingDoc = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(booking.bookingId)
        .get();
    final bookingData = bookingDoc.data() ?? <String, dynamic>{};

    final spaceDoc = await FirebaseFirestore.instance
        .collection('spaces')
        .doc(booking.spaceId)
        .get();
    final spaceData = spaceDoc.data() ?? <String, dynamic>{};

    final space = SpaceSummaryEntity(
      id: booking.spaceId,
      name: (spaceData['name'] as String?) ?? booking.spaceName,
      basePricePerDay:
          (spaceData['pricePerDay'] as num?)?.toInt() ??
          (spaceData['basePricePerDay'] as num?)?.toInt() ??
          booking.totalPrice.toInt(),
      currency: (spaceData['currency'] as String?) ?? booking.currency,
    );

    final startDate = bookingData['startDate'] is Timestamp
        ? (bookingData['startDate'] as Timestamp).toDate()
        : _parseDate(booking.dateText);

    final durationValue = (bookingData['durationValue'] as num?)?.toInt() ?? 1;
    final durationRaw = (bookingData['durationUnit'] as String?)?.toLowerCase();
    final durationUnit = switch (durationRaw) {
      'weeks' => DurationUnit.weeks,
      'months' => DurationUnit.months,
      _ => DurationUnit.days,
    };

    final purposeId = bookingData['purposeId'] as String?;
    final purposeLabel = bookingData['purposeLabel'] as String?;
    final offerId = bookingData['offerId'] as String?;
    final offerLabel = bookingData['offerLabel'] as String?;

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
        ..add(StartDateChanged(startDate))
        ..add(DurationUnitChanged(durationUnit))
        ..add(DurationValueChanged(durationValue));

      if (purposeId != null || purposeLabel != null) {
        bookingBloc.add(
          PurposeChanged(
            purposeId: purposeId ?? '',
            purposeLabel: purposeLabel ?? '',
          ),
        );
      }

      if (offerId != null || offerLabel != null) {
        bookingBloc.add(
          OfferChanged(
            offerId: offerId,
            offerLabel: offerLabel,
          ),
        );
      }
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
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _searchBar(String hintText, String aiLabel) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [AppColors.amber, AppColors.secondary],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              aiLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
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
          return Center(child: Text('Error: ${state.error}'));
        }

        final list = state.bookings;

        final upcoming = list
            .where((b) => b.status.toLowerCase() == 'upcoming')
            .toList();

        final awaitingConfirmation = list
            .where((b) => b.status.toLowerCase() == 'awaiting_confirmation')
            .toList();

        final confirmed = list
            .where((b) => b.status.toLowerCase() == 'confirmed')
            .toList();

        final completed = list
            .where((b) => b.status.toLowerCase() == 'completed')
            .toList();

        final cancelled = list
            .where((b) => b.status.toLowerCase() == 'cancelled')
            .toList();

        final q = _search.text.trim().toLowerCase();

        List<BookingEntity> filter(List<BookingEntity> src) {
          if (q.isEmpty) return src;
          return src.where((b) {
            return b.spaceName.toLowerCase().contains(q) ||
                b.bookingId.toLowerCase().contains(q);
          }).toList();
        }

        final upcomingF = filter(upcoming);
        final awaitingConfirmationF = filter(awaitingConfirmation);
        final confirmedF = filter(confirmed);
        final completedF = filter(completed);
        final cancelledF = filter(cancelled);

        final tabs = [
          context.t('upcomingBookings'),
          context.t('awaitingConfirmationTab'),
          context.t('confirmedBookingsTab'),
          context.t('pastBookings'),
          context.t('cancelledBookings'),
        ];

        final tabData = [
          upcomingF,
          awaitingConfirmationF,
          confirmedF,
          completedF,
          cancelledF,
        ];
        final currentList = tabData[_activeTabIndex];

        return RefreshIndicator(
          onRefresh: () async => bloc.add(const BookingsRefreshRequested()),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              const SizedBox(height: 6),
              Text(
                context.t('navBookings'),
                style: AppTextStyles.sectionBarTitle,
              ),
              const SizedBox(height: 14),
              _searchBar(
                context.t('searchHint'),
                context.t('aiConcierge'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final active = _activeTabIndex == i;
                    return ChoiceChip(
                      label: Text(tabs[i]),
                      selected: active,
                      onSelected: (_) => setState(() => _activeTabIndex = i),
                      selectedColor: AppColors.amber,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: active ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: active ? AppColors.amber : AppColors.inputBorder,
                        ),
                      ),
                    );
                  },
                ),
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
                  onRebook: _activeTabIndex == 3
                      ? () async {
                          await _rebookFromBooking(context, b);
                        }
                      : null,
                ),
              ),

              if (currentList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(context.t('noBookingsYet')),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
