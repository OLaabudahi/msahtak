import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

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
  final String? avatarUrl;

  const UpdateProfileRequested({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, email, phone, avatarUrl];
}

class ChangePasswordRequested extends ProfileEvent {
  const ChangePasswordRequested();
}

class VerifyEmailRequested extends ProfileEvent {
  const VerifyEmailRequested();
}
class CheckEmailVerifiedRequested extends ProfileEvent {

}

class ProfileAvatarUploadRequested extends ProfileEvent {
  final XFile file;

  const ProfileAvatarUploadRequested(this.file);

  @override
  List<Object?> get props => [file.path];
}
