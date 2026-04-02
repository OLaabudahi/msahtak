import 'package:Msahtak/features/bookings/domain/entities/booking_entity.dart';
import 'package:equatable/equatable.dart';

class BookingsState extends Equatable {
  final bool loading;
  final String? error;

  final int segmentIndex; // 0 upcoming, 1 past
  final List<BookingEntity> bookings;

  const BookingsState({
    required this.loading,
    required this.error,
    required this.segmentIndex,
    required this.bookings,
  });

  factory BookingsState.initial() => const BookingsState(
    loading: true,
    error: null,
    segmentIndex: 0,
    bookings: [],
  );

  List<BookingEntity> get upcoming =>
      bookings.where((b) => b.status == 'upcoming' || b.status == 'confirmed').toList();

  List<BookingEntity> get past =>
      bookings.where((b) => b.status != 'upcoming' && b.status != 'confirmed').toList();

  BookingsState copyWith({
    bool? loading,
    String? error,
    int? segmentIndex,
    List<BookingEntity>? bookings,
  }) {
    return BookingsState(
      loading: loading ?? this.loading,
      error: error,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      bookings: bookings ?? this.bookings,
    );
  }

  @override
  List<Object?> get props => [loading, error, segmentIndex, bookings];
}


