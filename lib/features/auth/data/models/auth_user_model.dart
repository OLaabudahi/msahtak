import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.fullName,
     required super.role,
     required super.assignedSpaceIds,
  });


  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    final user = map['user'];

    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      role: map['role'] ?? 'user',
      assignedSpaceIds: (map['assignedSpaceIds'] ?? [])
          .map<String>((e) => e.toString())
          .toList(),
    );
  }

  void operator [](String other) {}
}