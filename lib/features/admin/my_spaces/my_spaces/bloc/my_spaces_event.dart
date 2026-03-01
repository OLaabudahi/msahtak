import 'package:equatable/equatable.dart';

sealed class MySpacesEvent extends Equatable {
  const MySpacesEvent();
  @override
  List<Object?> get props => [];
}

class MySpacesStarted extends MySpacesEvent {
  const MySpacesStarted();
}

class MySpacesHidePressed extends MySpacesEvent {
  final String spaceId;
  const MySpacesHidePressed(this.spaceId);
  @override
  List<Object?> get props => [spaceId];
}
