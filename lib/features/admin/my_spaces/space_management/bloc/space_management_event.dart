import 'package:equatable/equatable.dart';

sealed class SpaceManagementEvent extends Equatable {
  const SpaceManagementEvent();
  @override
  List<Object?> get props => [];
}

class SpaceManagementStarted extends SpaceManagementEvent {
  final String spaceId;
  const SpaceManagementStarted(this.spaceId);
  @override
  List<Object?> get props => [spaceId];
}

class SpaceManagementHiddenToggled extends SpaceManagementEvent {
  final String spaceId;
  final bool hidden;
  const SpaceManagementHiddenToggled(this.spaceId, this.hidden);
  @override
  List<Object?> get props => [spaceId, hidden];
}
