import 'package:equatable/equatable.dart';

abstract class WeeklyPlanEvent extends Equatable {
  const WeeklyPlanEvent();
  @override
  List<Object?> get props => [];
}


class WeeklyPlanStarted extends WeeklyPlanEvent {
  const WeeklyPlanStarted();
}


class WeeklyPlanHubChanged extends WeeklyPlanEvent {
  final String hubId;
  const WeeklyPlanHubChanged(this.hubId);
  @override
  List<Object?> get props => [hubId];
}


class WeeklyPlanActivatePressed extends WeeklyPlanEvent {
  const WeeklyPlanActivatePressed();
}
