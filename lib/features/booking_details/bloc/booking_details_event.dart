import 'package:equatable/equatable.dart';

sealed class BookingDetailsEvent extends Equatable {
  const BookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// ✅ حدث: تحميل تفاصيل الحجز
class BookingDetailsStarted extends BookingDetailsEvent {
  final String bookingId;
  const BookingDetailsStarted(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
