import 'package:equatable/equatable.dart';

class ProfileUsageEvent extends Equatable {
  const ProfileUsageEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUsageStarted extends ProfileUsageEvent {
  const ProfileUsageStarted();
}
