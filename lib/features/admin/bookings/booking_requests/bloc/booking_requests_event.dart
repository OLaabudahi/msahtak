import 'package:equatable/equatable.dart';
import '../domain/entities/booking_status.dart';

sealed class BookingRequestsEvent extends Equatable {
  const BookingRequestsEvent();
  @override
  List<Object?> get props => [];
}

class BookingRequestsStarted extends BookingRequestsEvent {
  const BookingRequestsStarted();
}

class BookingRequestsTabChanged extends BookingRequestsEvent {
  final BookingStatus tab;
  const BookingRequestsTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

class BookingRequestsAccepted extends BookingRequestsEvent {
  final String bookingId;
  const BookingRequestsAccepted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class BookingRequestsRejected extends BookingRequestsEvent {
  final String bookingId;
  const BookingRequestsRejected(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}


