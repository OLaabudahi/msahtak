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
  });

  @override
  List<Object?> get props => [id, userName, userAvatar, date, time, duration, plan, space, status];
}
