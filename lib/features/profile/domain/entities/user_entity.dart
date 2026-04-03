import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;

  final int totalBookings;
  final int completedBookings;
  final int savedSpaces;

  final bool isEmailVerified;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    required this.totalBookings,
    required this.completedBookings,
    required this.savedSpaces,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber,
    avatarUrl,
    totalBookings,
    completedBookings,
    savedSpaces,
    isEmailVerified,
  ];
}