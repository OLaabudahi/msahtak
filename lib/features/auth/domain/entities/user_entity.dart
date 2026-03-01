import 'package:equatable/equatable.dart';

enum UserRole { user, admin }

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [id, fullName, email, role];
}