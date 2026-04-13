import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_booking_details_usecase.dart';
import 'booking_details_event.dart';
import 'booking_details_state.dart';

class BookingDetailsBloc extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsBloc({required this.getBookingDetailsUseCase})
      : super(BookingDetailsState.initial()) {
    on<BookingDetailsStarted>(_onLoad);
    on<BookingDetailsRefreshRequested>(_onLoad);
  }

  final GetBookingDetailsUseCase getBookingDetailsUseCase;

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
      final data = await getBookingDetailsUseCase(bookingId);
      emit(state.copyWith(loading: false, data: data));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
