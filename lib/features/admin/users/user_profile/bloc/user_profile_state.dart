import 'package:equatable/equatable.dart';
import '../domain/entities/user_profile_entity.dart';

enum UserProfileStatus { initial, loading, ready, acting, failure }

class UserProfileState extends Equatable {
  final UserProfileStatus status;
  final UserProfileEntity? profile;
  final String? error;

  const UserProfileState({
    required this.status,
    required this.profile,
    required this.error,
  });

  factory UserProfileState.initial() => const UserProfileState(status: UserProfileStatus.initial, profile: null, error: null);

  UserProfileState copyWith({UserProfileStatus? status, UserProfileEntity? profile, String? error}) {
    return UserProfileState(status: status ?? this.status, profile: profile ?? this.profile, error: error);
  }

  @override
  List<Object?> get props => [status, profile, error];
}


