import 'package:equatable/equatable.dart';

abstract class WeeklyPlanEvent extends Equatable {
  const WeeklyPlanEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ط¨ظٹط§ظ†ط§طھ ط§ظ„ط®ط·ط© ط§ظ„ط£ط³ط¨ظˆط¹ظٹط©
class WeeklyPlanStarted extends WeeklyPlanEvent {
  const WeeklyPlanStarted();
}

/// طھط؛ظٹظٹط± ط§ظ„ظ…ط³ط§ط­ط© ط§ظ„ظ…ط®طھط§ط±ط©
class WeeklyPlanHubChanged extends WeeklyPlanEvent {
  final String hubId;
  const WeeklyPlanHubChanged(this.hubId);
  @override
  List<Object?> get props => [hubId];
}

/// ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ ط²ط± طھظپط¹ظٹظ„ ط§ظ„ط®ط·ط©
class WeeklyPlanActivatePressed extends WeeklyPlanEvent {
  const WeeklyPlanActivatePressed();
}


