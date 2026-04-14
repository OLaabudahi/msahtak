import 'package:equatable/equatable.dart';

class UserReceiptEntity extends Equatable {
  final String bookingId;
  final String spaceName;
  final String userName;
  final String userEmail;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentMethod;
  final double totalPrice;
  final String currency;
  final String status;
  final DateTime createdAt;

  const UserReceiptEntity({
    required this.bookingId,
    required this.spaceName,
    required this.userName,
    required this.userEmail,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        bookingId,
        spaceName,
        userName,
        userEmail,
        startDate,
        endDate,
        paymentMethod,
        totalPrice,
        currency,
        status,
        createdAt,
      ];
}
