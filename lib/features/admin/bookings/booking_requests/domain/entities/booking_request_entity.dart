import 'package:equatable/equatable.dart';
import 'booking_status.dart';

class BookingRequestEntity extends Equatable {
  final String id;
  final String userName;
  final String userAvatar;
  final String date;
  final String time;
  final String duration;
  final String plan;
  final String space;
  final BookingStatus status;
  final String spaceId;
  final int totalSeats;
  final int availableSeats;

  const BookingRequestEntity({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.time,
    required this.duration,
    required this.plan,
    required this.space,
    required this.status,
    this.spaceId = '',
    this.totalSeats = 0,
    this.availableSeats = 0,
  });

  bool get seatsExhausted => totalSeats > 0 && availableSeats <= 0;

  @override
  List<Object?> get props => [id, userName, userAvatar, date, time, duration, plan, space, status, spaceId, totalSeats, availableSeats];
}


