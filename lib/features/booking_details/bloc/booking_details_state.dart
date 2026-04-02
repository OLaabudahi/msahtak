import 'package:equatable/equatable.dart';
import '../data/models/booking_details_model.dart';

class BookingDetailsState extends Equatable {
  final bool loading;
  final String? error;
  final BookingDetails? data;

  const BookingDetailsState({
    required this.loading,
    required this.error,
    required this.data,
  });

  factory BookingDetailsState.initial() {
    return const BookingDetailsState(loading: true, error: null, data: null);
  }

  BookingDetailsState copyWith({
    bool? loading,
    String? error,
    BookingDetails? data,
    bool clearError = false,
  }) {
    return BookingDetailsState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [loading, error, data];
}
