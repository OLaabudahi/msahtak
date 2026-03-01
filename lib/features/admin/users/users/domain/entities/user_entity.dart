import 'package:equatable/equatable.dart';

enum UserStatus { active, blocked }

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final UserStatus status;
  final bool flagged;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.flagged,
  });

  @override
  List<Object?> get props => [id, name, avatar, status, flagged];
}
