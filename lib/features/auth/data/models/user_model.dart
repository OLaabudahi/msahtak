import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final String id;
  final String fullName;
  final String email;

  // API-ready (commented)
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json['id'].toString(),
  //     fullName: json['full_name'] as String,
  //     email: json['email'] as String,
  //   );
  // }

  @override
  List<Object?> get props => [id, fullName, email];
}


