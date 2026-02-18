import 'package:equatable/equatable.dart';

/// ✅ موديل بيانات المستخدم
class UserModel extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String? avatarAsset;
  final String? avatarUrl;

  final int totalBookings;
  final int completedBookings;
  final int savedSpaces;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.avatarAsset,
    this.avatarUrl,
    required this.totalBookings,
    required this.completedBookings,
    required this.savedSpaces,
  });

  /// ✅ API READY (كومنت)
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     userId: json['userId'].toString(),
  //     fullName: json['fullName'] ?? '',
  //     email: json['email'] ?? '',
  //     avatarUrl: json['avatarUrl'],
  //     totalBookings: json['totalBookings'] ?? 0,
  //     completedBookings: json['completedBookings'] ?? 0,
  //     savedSpaces: json['savedSpaces'] ?? 0,
  //   );
  // }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    avatarAsset,
    avatarUrl,
    totalBookings,
    completedBookings,
    savedSpaces,
  ];
}
