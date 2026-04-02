import 'package:equatable/equatable.dart';

abstract class BestForYouEvent extends Equatable {
  const BestForYouEvent();
  @override
  List<Object?> get props => [];
}


class BestForYouStarted extends BestForYouEvent {
  const BestForYouStarted();
}


class BestForYouGoalChanged extends BestForYouEvent {
  final String goal;
  const BestForYouGoalChanged(this.goal);
  @override
  List<Object?> get props => [goal];
}


class BestForYouContinuePressed extends BestForYouEvent {
  const BestForYouContinuePressed();
}
