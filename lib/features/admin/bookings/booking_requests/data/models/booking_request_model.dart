import '../../domain/entities/booking_request_entity.dart';
import '../../domain/entities/booking_status.dart';

class BookingRequestModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String date;
  final String time;
  final String duration;
  final String plan;
  final String space;
  final String status;
  final String spaceId;
  final int totalSeats;
  final int availableSeats;

  const BookingRequestModel({
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

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) => BookingRequestModel(
        id: (json['id'] ?? '').toString(),
        userName: (json['userName'] ?? '').toString(),
        userAvatar: (json['userAvatar'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        time: (json['time'] ?? '').toString(),
        duration: (json['duration'] ?? '').toString(),
        plan: (json['plan'] ?? '').toString(),
        space: (json['space'] ?? '').toString(),
        status: (json['status'] ?? 'pending').toString(),
      );

  Map<String, dynamic> toJson() => {'id': id, 'userName': userName, 'userAvatar': userAvatar, 'date': date, 'time': time, 'duration': duration, 'plan': plan, 'space': space, 'status': status};

  BookingRequestEntity toEntity() => BookingRequestEntity(
        id: id,
        userName: userName,
        userAvatar: userAvatar,
        date: date,
        time: time,
        duration: duration,
        plan: plan,
        space: space,
        status: _parse(status),
        spaceId: spaceId,
        totalSeats: totalSeats,
        availableSeats: availableSeats,
      );

  BookingStatus _parse(String s) => switch (s) { 'approved' => BookingStatus.approved, 'canceled' => BookingStatus.canceled, _ => BookingStatus.pending };
}
