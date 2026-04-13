import 'dart:async';

import 'package:bloc/bloc.dart';

import '../domain/usecases/cancel_booking_usecase.dart';
import '../domain/usecases/get_bookings_usecase.dart';
import '../domain/usecases/listen_bookings_updates_usecase.dart';
import 'bookings_event.dart';
import 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingsUseCase getBookings;
  final CancelBookingUseCase cancelBooking;
  final ListenBookingsUpdatesUseCase listenBookingsUpdates;

  StreamSubscription? _updatesSubscription;

  BookingsBloc({
    required this.getBookings,
    required this.cancelBooking,
    required this.listenBookingsUpdates,
  }) : super(BookingsState.initial()) {
    on<BookingsStarted>(_onStarted);
    on<BookingsSegmentChanged>(_onSegmentChanged);
    on<BookingsRefreshRequested>(_onRefresh);
    on<BookingsCancelRequested>(_onCancel);
    on<BookingsUpdatesReceived>(_onUpdatesReceived);
  }

  Future<void> _onStarted(
    BookingsStarted event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final data = await getBookings();
      emit(state.copyWith(loading: false, bookings: data, error: null));

      await _updatesSubscription?.cancel();
      _updatesSubscription = listenBookingsUpdates().listen((items) {
        add(BookingsUpdatesReceived(items));
      });
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
          bookings: const [],
        ),
      );
    }
  }

  void _onSegmentChanged(
    BookingsSegmentChanged event,
    Emitter<BookingsState> emit,
  ) {
    emit(state.copyWith(segmentIndex: event.index));
  }

  Future<void> _onRefresh(
    BookingsRefreshRequested event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      final data = await getBookings();
      emit(state.copyWith(bookings: data, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCancel(
    BookingsCancelRequested event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      await cancelBooking(event.bookingId);
      final data = await getBookings();
      emit(state.copyWith(bookings: data, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdatesReceived(
    BookingsUpdatesReceived event,
    Emitter<BookingsState> emit,
  ) {
    emit(state.copyWith(bookings: event.bookings, error: null));
  }

  @override
  Future<void> close() async {
    await _updatesSubscription?.cancel();
    return super.close();
  }
}
