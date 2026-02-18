import 'package:equatable/equatable.dart';
import '../data/models/booking_details_model.dart';

class BookingDetailsState extends Equatable {
  final bool loading;
  final BookingDetails? data;
  final String? error;

  const BookingDetailsState({
    required this.loading,
    required this.data,
    required this.error,
  });

  factory BookingDetailsState.initial() =>
      const BookingDetailsState(loading: true, data: null, error: null);

  BookingDetailsState copyWith({
    bool? loading,
    BookingDetails? data,
    String? error,
  }) {
    return BookingDetailsState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, data, error];
}
