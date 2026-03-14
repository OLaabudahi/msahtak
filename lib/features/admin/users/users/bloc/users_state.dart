import 'package:equatable/equatable.dart';
import '../domain/entities/user_entity.dart';
import '../domain/entities/user_flag.dart';

enum UsersStatus { initial, loading, success, failure }

class UsersState extends Equatable {
  final UsersStatus status;
  final String query;
  final UserFlag filter;
  final List<UserEntity> users;
  final String? error;

  const UsersState({
    required this.status,
    required this.query,
    required this.filter,
    required this.users,
    required this.error,
  });

  factory UsersState.initial() => const UsersState(
        status: UsersStatus.initial,
        query: '',
        filter: UserFlag.all,
        users: [],
        error: null,
      );

  UsersState copyWith({
    UsersStatus? status,
    String? query,
    UserFlag? filter,
    List<UserEntity>? users,
    String? error,
  }) {
    return UsersState(
      status: status ?? this.status,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      users: users ?? this.users,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, query, filter, users, error];
}
