import 'package:equatable/equatable.dart';

sealed class SpaceDetailsEvent extends Equatable {
  const SpaceDetailsEvent();
  @override
  List<Object?> get props => [];
}

class SpaceDetailsStarted extends SpaceDetailsEvent {
  final String spaceId;
  const SpaceDetailsStarted(this.spaceId);
  @override
  List<Object?> get props => [spaceId];
}

class SpaceDetailsTabChanged extends SpaceDetailsEvent {
  final int index; 
  const SpaceDetailsTabChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class SpaceDetailsCarouselChanged extends SpaceDetailsEvent {
  final int index;
  const SpaceDetailsCarouselChanged(this.index);
  @override
  List<Object?> get props => [index];
}


