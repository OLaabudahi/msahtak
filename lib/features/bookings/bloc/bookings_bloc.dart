import 'package:bloc/bloc.dart';

import '../domain/usecases/get_bookings_usecase.dart';
import '../domain/usecases/cancel_booking_usecase.dart';

import 'bookings_event.dart';
import 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingsUseCase getBookings;
  final CancelBookingUseCase cancelBooking;

  BookingsBloc({
    required this.getBookings,
    required this.cancelBooking,
  }) : super(BookingsState.initial()) {
    on<BookingsStarted>(_onStarted);
    on<BookingsSegmentChanged>(_onSegmentChanged);
    on<BookingsRefreshRequested>(_onRefresh);
    on<BookingsCancelRequested>(_onCancel);
  }

  /// âœ… طھط­ظ…ظٹظ„ ط§ظ„ط­ط¬ظˆط²ط§طھ
  Future<void> _onStarted(
      BookingsStarted event,
      Emitter<BookingsState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await getBookings();
      emit(state.copyWith(loading: false, bookings: data, error: null));
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

  /// âœ… طھط؛ظٹظٹط± ط§ظ„طھط§ط¨
  void _onSegmentChanged(
      BookingsSegmentChanged event,
      Emitter<BookingsState> emit,
      ) {
    emit(state.copyWith(segmentIndex: event.index));
  }

  /// âœ… ط±ظٹظپط±ظٹط´
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

  /// âœ… ط¥ظ„ط؛ط§ط، ط­ط¬ط²
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
}

