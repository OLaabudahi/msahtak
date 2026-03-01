import 'package:equatable/equatable.dart';

sealed class AdminHomeEvent extends Equatable {
  const AdminHomeEvent();
  @override
  List<Object?> get props => [];
}

class AdminHomeStarted extends AdminHomeEvent {
  const AdminHomeStarted();
}

class AdminHomeSpaceChanged extends AdminHomeEvent {
  final String spaceId;
  const AdminHomeSpaceChanged(this.spaceId);
  @override
  List<Object?> get props => [spaceId];
}
