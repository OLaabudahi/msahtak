import 'package:equatable/equatable.dart';

sealed class BookingDetailsEvent extends Equatable {
  const BookingDetailsEvent();
  @override
  List<Object?> get props => [];
}

class BookingDetailsStarted extends BookingDetailsEvent {
  final String bookingId;
  const BookingDetailsStarted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class BookingDetailsConfirmed extends BookingDetailsEvent {
  final String bookingId;
  const BookingDetailsConfirmed(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class BookingDetailsCanceled extends BookingDetailsEvent {
  final String bookingId;
  final String reason;
  const BookingDetailsCanceled(this.bookingId, this.reason);
  @override
  List<Object?> get props => [bookingId, reason];
}
