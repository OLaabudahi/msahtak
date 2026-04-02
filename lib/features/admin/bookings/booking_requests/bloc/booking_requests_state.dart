import 'package:equatable/equatable.dart';
import '../domain/entities/booking_request_entity.dart';
import '../domain/entities/booking_status.dart';

enum BookingRequestsLoadStatus { initial, loading, success, failure }

class BookingRequestsState extends Equatable {
  final BookingRequestsLoadStatus status;
  final BookingStatus activeTab;
  final List<BookingRequestEntity> bookings;
  final String? error;

  const BookingRequestsState({
    required this.status,
    required this.activeTab,
    required this.bookings,
    required this.error,
  });

  factory BookingRequestsState.initial() => const BookingRequestsState(
        status: BookingRequestsLoadStatus.initial,
        activeTab: BookingStatus.pending,
        bookings: [],
        error: null,
      );

  BookingRequestsState copyWith({
    BookingRequestsLoadStatus? status,
    BookingStatus? activeTab,
    List<BookingRequestEntity>? bookings,
    String? error,
  }) =>
      BookingRequestsState(
        status: status ?? this.status,
        activeTab: activeTab ?? this.activeTab,
        bookings: bookings ?? this.bookings,
        error: error,
      );

  @override
  List<Object?> get props => [status, activeTab, bookings, error];
}


