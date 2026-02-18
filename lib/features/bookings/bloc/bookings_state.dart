import 'package:equatable/equatable.dart';
import '../data/models/booking_model.dart';

class BookingsState extends Equatable {
  final bool loading;
  final String? error;

  final int segmentIndex; // 0 upcoming, 1 past
  final List<Booking> all;

  const BookingsState({
    required this.loading,
    required this.error,
    required this.segmentIndex,
    required this.all,
  });

  factory BookingsState.initial() => const BookingsState(
    loading: true,
    error: null,
    segmentIndex: 0,
    all: [],
  );

  List<Booking> get upcoming =>
      all.where((b) => b.status == 'upcoming').toList();

  List<Booking> get past =>
      all.where((b) => b.status != 'upcoming').toList();

  BookingsState copyWith({
    bool? loading,
    String? error,
    int? segmentIndex,
    List<Booking>? all,
  }) {
    return BookingsState(
      loading: loading ?? this.loading,
      error: error,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      all: all ?? this.all,
    );
  }

  @override
  List<Object?> get props => [loading, error, segmentIndex, all];
}
