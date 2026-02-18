import 'package:bloc/bloc.dart';

import '../data/repos/booking_details_repo.dart';
import 'booking_details_event.dart';
import 'booking_details_state.dart';

class BookingDetailsBloc extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  final BookingDetailsRepo repo;

  BookingDetailsBloc({required this.repo}) : super(BookingDetailsState.initial()) {
    on<BookingDetailsStarted>(_onStarted);
  }

  /// ✅ دالة: تحميل تفاصيل الحجز من repo (Dummy حالياً)
  Future<void> _onStarted(
      BookingDetailsStarted event,
      Emitter<BookingDetailsState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final details = await repo.fetchBookingDetails(event.bookingId);
      emit(state.copyWith(loading: false, data: details, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, data: null, error: e.toString()));
    }
  }
}
