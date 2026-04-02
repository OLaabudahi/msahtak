import 'package:equatable/equatable.dart';

sealed class BookingsEvent extends Equatable {
  const BookingsEvent();
  @override
  List<Object?> get props => [];
}

class BookingsStarted extends BookingsEvent {
  const BookingsStarted();
}

class BookingsSegmentChanged extends BookingsEvent {
  
  final int index;
  const BookingsSegmentChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class BookingsRefreshRequested extends BookingsEvent {
  const BookingsRefreshRequested();
}

class BookingsCancelRequested extends BookingsEvent {
  final String bookingId;
  const BookingsCancelRequested(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}


