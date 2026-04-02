import 'package:equatable/equatable.dart';

class BookingDetailsEntity extends Equatable {
  final String id;
  final String bookingCode;
  final String userName;
  final String userAvatar;
  final String userPhone;
  final String userEmail;

  final String space;
  final String spaceAddress;

  final String date;
  final String time;
  final String duration;
  final String plan;
  final String price;
  final String total;

  final String status;

  const BookingDetailsEntity({
    required this.id,
    required this.bookingCode,
    required this.userName,
    required this.userAvatar,
    required this.userPhone,
    required this.userEmail,
    required this.space,
    required this.spaceAddress,
    required this.date,
    required this.time,
    required this.duration,
    required this.plan,
    required this.price,
    required this.total,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        bookingCode,
        userName,
        userAvatar,
        userPhone,
        userEmail,
        space,
        spaceAddress,
        date,
        time,
        duration,
        plan,
        price,
        total,
        status,
      ];
}


