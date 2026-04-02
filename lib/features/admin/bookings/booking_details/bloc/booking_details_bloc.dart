import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/cancel_booking_usecase.dart';
import '../domain/usecases/confirm_booking_usecase.dart';
import '../domain/usecases/get_booking_details_usecase.dart';
import 'booking_details_event.dart';
import 'booking_details_state.dart';

class BookingDetailsBloc extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  final GetBookingDetailsUseCase getDetails;
  final ConfirmBookingUseCase confirm;
  final CancelBookingUseCase cancel;

  BookingDetailsBloc({
    required this.getDetails,
    required this.confirm,
    required this.cancel,
  }) : super(BookingDetailsState.initial()) {
    on<BookingDetailsStarted>(_onStarted);
    on<BookingDetailsConfirmed>(_onConfirmed);
    on<BookingDetailsCanceled>(_onCanceled);
  }

  Future<void> _onStarted(BookingDetailsStarted event, Emitter<BookingDetailsState> emit) async {
    emit(state.copyWith(status: BookingDetailsStatus.loading, error: null));
    try {
      final d = await getDetails(bookingId: event.bookingId);
      emit(state.copyWith(status: BookingDetailsStatus.success, details: d));
    } catch (e) {
      emit(state.copyWith(status: BookingDetailsStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onConfirmed(BookingDetailsConfirmed event, Emitter<BookingDetailsState> emit) async {
    emit(state.copyWith(status: BookingDetailsStatus.acting, error: null));
    try {
      await confirm(bookingId: event.bookingId);
      emit(state.copyWith(status: BookingDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BookingDetailsStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onCanceled(BookingDetailsCanceled event, Emitter<BookingDetailsState> emit) async {
    emit(state.copyWith(status: BookingDetailsStatus.acting, error: null));
    try {
      await cancel(bookingId: event.bookingId, reason: event.reason);
      emit(state.copyWith(status: BookingDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BookingDetailsStatus.failure, error: e.toString()));
    }
  }
}


