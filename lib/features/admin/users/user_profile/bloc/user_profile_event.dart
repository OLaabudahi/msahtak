import 'package:equatable/equatable.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object?> get props => [];
}

class UserProfileStarted extends UserProfileEvent {
  final String userId;
  const UserProfileStarted(this.userId);
  @override
  List<Object?> get props => [userId];
}

class UserProfileApprovePressed extends UserProfileEvent {
  final String userId;
  const UserProfileApprovePressed(this.userId);
  @override
  List<Object?> get props => [userId];
}

class UserProfileBlockPressed extends UserProfileEvent {
  final String userId;
  const UserProfileBlockPressed(this.userId);
  @override
  List<Object?> get props => [userId];
}

class UserProfileAddNotePressed extends UserProfileEvent {
  final String userId;
  final String note;
  const UserProfileAddNotePressed(this.userId, this.note);
  @override
  List<Object?> get props => [userId, note];
}
