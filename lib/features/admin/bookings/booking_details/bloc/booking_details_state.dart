import 'package:equatable/equatable.dart';
import '../domain/entities/booking_details_entity.dart';

enum BookingDetailsStatus { initial, loading, success, failure, acting }

class BookingDetailsState extends Equatable {
  final BookingDetailsStatus status;
  final BookingDetailsEntity? details;
  final String? error;

  const BookingDetailsState({
    required this.status,
    required this.details,
    required this.error,
  });

  factory BookingDetailsState.initial() => const BookingDetailsState(
        status: BookingDetailsStatus.initial,
        details: null,
        error: null,
      );

  BookingDetailsState copyWith({
    BookingDetailsStatus? status,
    BookingDetailsEntity? details,
    String? error,
  }) {
    return BookingDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, details, error];
}


