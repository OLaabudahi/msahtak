import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}
class UpdateProfileRequested extends ProfileEvent {
  final String name;
  final String email;
  final String phone;

  const UpdateProfileRequested({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, phone];
}

class ChangePasswordRequested extends ProfileEvent {
  const ChangePasswordRequested();
}

class VerifyEmailRequested extends ProfileEvent {
  const VerifyEmailRequested();
}
class CheckEmailVerifiedRequested extends ProfileEvent {

}

