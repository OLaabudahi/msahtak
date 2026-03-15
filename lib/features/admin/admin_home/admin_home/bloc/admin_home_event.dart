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
  final String spaceName;
  const AdminHomeSpaceChanged({required this.spaceId, required this.spaceName});
  @override
  List<Object?> get props => [spaceId, spaceName];
}
