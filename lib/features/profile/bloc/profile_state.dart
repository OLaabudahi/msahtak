import 'package:equatable/equatable.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user_entity.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? error;
  final UserEntity? user;

  const ProfileState({
    required this.loading,
    required this.error,
    required this.user,
  });

  factory ProfileState.initial() =>
      const ProfileState(loading: true, error: null, user: null);

  ProfileState copyWith({bool? loading, String? error, UserEntity? user}) {
    return ProfileState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [loading, error, user];

}


