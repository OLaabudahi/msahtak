import 'package:equatable/equatable.dart';

abstract class UsageEvent extends Equatable {
  const UsageEvent();
  @override
  List<Object?> get props => [];
}


class UsageStarted extends UsageEvent {
  const UsageStarted();
}


class UsagePlanSelected extends UsageEvent {
  final int index;
  const UsagePlanSelected(this.index);
  @override
  List<Object?> get props => [index];
}


class UsagePlanApplied extends UsageEvent {
  const UsagePlanApplied();
}
