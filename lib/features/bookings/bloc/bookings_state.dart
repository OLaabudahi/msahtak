import 'package:equatable/equatable.dart';
import '../data/models/booking_model.dart';

class BookingsState extends Equatable {
  final bool loading;
  final String? error;

  final int segmentIndex; 
  final List<Booking> bookings;

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

  List<Booking> get upcoming =>
      bookings.where((b) => b.status == 'upcoming' || b.status == 'confirmed').toList();

  List<Booking> get past =>
      bookings.where((b) => b.status != 'upcoming' && b.status != 'confirmed').toList();

  BookingsState copyWith({
    bool? loading,
    String? error,
    int? segmentIndex,
    List<Booking>? bookings,
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
