import 'package:bloc/bloc.dart';
import '../domain/repos/bookings_repo.dart';
import '../data/repos/bookings_repo_dummy.dart';
import 'bookings_event.dart';
import 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepo repo;

  BookingsBloc({BookingsRepo? repo})
    : repo = repo ?? BookingsRepoDummy(),
      super(BookingsState.initial()) {
    on<BookingsStarted>(_onStarted);
    on<BookingsSegmentChanged>(_onSegmentChanged);
    on<BookingsRefreshRequested>(_onRefresh);
    on<BookingsCancelRequested>(_onCancel);
  }

  /// ✅ دالة: تحميل الحجوزات أول ما تفتح التاب
  Future<void> _onStarted(
    BookingsStarted event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await repo.fetchBookings();
      emit(state.copyWith(loading: false, bookings: data, error: null));
    } catch (e) {
      emit(
        state.copyWith(loading: false, error: e.toString(), bookings: const []),
      );
    }
  }

  /// ✅ دالة: تغيير Segmented (Upcoming / Past)
  void _onSegmentChanged(
    BookingsSegmentChanged event,
    Emitter<BookingsState> emit,
  ) {
    emit(state.copyWith(segmentIndex: event.index));
  }

  /// ✅ دالة: ريفريش (Pull to refresh)
  Future<void> _onRefresh(
    BookingsRefreshRequested event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      final data = await repo.fetchBookings();
      emit(state.copyWith(bookings: data, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// إلغاء حجز وتحديث القائمة
  Future<void> _onCancel(
    BookingsCancelRequested event,
    Emitter<BookingsState> emit,
  ) async {
    try {
      await repo.cancelBooking(event.bookingId);
      final data = await repo.fetchBookings();
      emit(state.copyWith(bookings: data, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
