import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String status;
  final bool flagged;

  const UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.flagged,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        avatar: (json['avatar'] ?? '').toString(),
        status: (json['status'] ?? 'active').toString(),
        flagged: (json['flagged'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'status': status,
        'flagged': flagged,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        avatar: avatar,
        status: status == 'blocked' ? UserStatus.blocked : UserStatus.active,
        flagged: flagged,
      );
}
