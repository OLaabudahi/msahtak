import 'package:equatable/equatable.dart';


class UserModel extends Equatable {
  final String userId;
  final String fullName;
  final String email;

  final String? phoneNumber;

  final String? avatarAsset;
  final String? avatarUrl;

  final int totalBookings;
  final int completedBookings;
  final int savedSpaces;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatarAsset,
    this.avatarUrl,
    required this.totalBookings,
    required this.completedBookings,
    required this.savedSpaces,
  });

  
  
  
  
  
  
  
  
  
  
  
  
  

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber,
    avatarAsset,
    avatarUrl,
    totalBookings,
    completedBookings,
    savedSpaces,
  ];
}
