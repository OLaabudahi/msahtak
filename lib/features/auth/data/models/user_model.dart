import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role; // "admin" | "user"

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['full_name'] ?? json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'user').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'role': role,
      };

  UserEntity toEntity() {
    final r = role.toLowerCase() == 'admin' ? UserRole.admin : UserRole.user;
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      role: r,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, role];
}