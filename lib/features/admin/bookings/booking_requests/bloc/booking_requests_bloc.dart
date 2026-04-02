import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/booking_status.dart';
import '../domain/usecases/accept_booking_usecase.dart';
import '../domain/usecases/get_bookings_usecase.dart';
import '../domain/usecases/reject_booking_usecase.dart';
import 'booking_requests_event.dart';
import 'booking_requests_state.dart';

class BookingRequestsBloc extends Bloc<BookingRequestsEvent, BookingRequestsState> {
  final GetBookingsUseCase getBookings;
  final AcceptBookingUseCase acceptBooking;
  final RejectBookingUseCase rejectBooking;

  BookingRequestsBloc({
    required this.getBookings,
    required this.acceptBooking,
    required this.rejectBooking,
  }) : super(BookingRequestsState.initial()) {
    on<BookingRequestsStarted>(_onStarted);
    on<BookingRequestsTabChanged>(_onTabChanged);
    on<BookingRequestsAccepted>(_onAccepted);
    on<BookingRequestsRejected>(_onRejected);
  }

  Future<void> _load(Emitter<BookingRequestsState> emit, BookingStatus tab) async {
    emit(state.copyWith(status: BookingRequestsLoadStatus.loading, activeTab: tab, error: null));
    try {
      final list = await getBookings(status: tab);
      emit(state.copyWith(status: BookingRequestsLoadStatus.success, bookings: list));
    } catch (e) {
      emit(state.copyWith(status: BookingRequestsLoadStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onStarted(BookingRequestsStarted event, Emitter<BookingRequestsState> emit) async => _load(emit, state.activeTab);

  Future<void> _onTabChanged(BookingRequestsTabChanged event, Emitter<BookingRequestsState> emit) async {
    
    if (event.tab == BookingStatus.paymentReview) {
      emit(state.copyWith(activeTab: event.tab, bookings: [], status: BookingRequestsLoadStatus.success));
      return;
    }
    return _load(emit, event.tab);
  }

  Future<void> _onAccepted(BookingRequestsAccepted event, Emitter<BookingRequestsState> emit) async {
    await acceptBooking(bookingId: event.bookingId);
    await _load(emit, state.activeTab);
  }

  Future<void> _onRejected(BookingRequestsRejected event, Emitter<BookingRequestsState> emit) async {
    await rejectBooking(bookingId: event.bookingId);
    await _load(emit, state.activeTab);
  }
}
