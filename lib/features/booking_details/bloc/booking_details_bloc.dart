import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repos/booking_details_repo.dart';
import 'booking_details_event.dart';
import 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsBloc({required this.repo})
    : super(BookingDetailsState.initial()) {
    on<BookingDetailsStarted>(_onLoad);
    on<BookingDetailsRefreshRequested>(_onLoad);
  }

  final BookingDetailsRepo repo;

  Future<void> _onLoad(
    BookingDetailsEvent event,
    Emitter<BookingDetailsState> emit,
  ) async {
    final bookingId = switch (event) {
      BookingDetailsStarted(:final bookingId) => bookingId,
      BookingDetailsRefreshRequested(:final bookingId) => bookingId,
      _ => '',
    };

    emit(state.copyWith(loading: true, clearError: true));

    try {
      final data = await repo.fetchBookingDetails(bookingId);
      emit(state.copyWith(loading: false, data: data));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}


