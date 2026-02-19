import 'package:equatable/equatable.dart';
import '../data/models/user_model.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? error;
  final UserModel? user;

  const ProfileState({
    required this.loading,
    required this.error,
    required this.user,
  });

  factory ProfileState.initial() =>
      const ProfileState(loading: true, error: null, user: null);

  ProfileState copyWith({bool? loading, String? error, UserModel? user}) {
    return ProfileState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [loading, error, user];
}
