import '../../domain/entities/booking_details_entity.dart';

class BookingDetailsModel {
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

  const BookingDetailsModel({
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

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      id: (json['id'] ?? '').toString(),
      bookingCode: (json['bookingCode'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      userAvatar: (json['userAvatar'] ?? '').toString(),
      userPhone: (json['userPhone'] ?? '').toString(),
      userEmail: (json['userEmail'] ?? '').toString(),
      space: (json['space'] ?? '').toString(),
      spaceAddress: (json['spaceAddress'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      duration: (json['duration'] ?? '').toString(),
      plan: (json['plan'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      total: (json['total'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingCode': bookingCode,
        'userName': userName,
        'userAvatar': userAvatar,
        'userPhone': userPhone,
        'userEmail': userEmail,
        'space': space,
        'spaceAddress': spaceAddress,
        'date': date,
        'time': time,
        'duration': duration,
        'plan': plan,
        'price': price,
        'total': total,
        'status': status,
      };

  BookingDetailsEntity toEntity() {
    return BookingDetailsEntity(
      id: id,
      bookingCode: bookingCode,
      userName: userName,
      userAvatar: userAvatar,
      userPhone: userPhone,
      userEmail: userEmail,
      space: space,
      spaceAddress: spaceAddress,
      date: date,
      time: time,
      duration: duration,
      plan: plan,
      price: price,
      total: total,
      status: status,
    );
  }
}
