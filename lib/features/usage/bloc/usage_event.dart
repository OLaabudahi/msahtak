import 'package:equatable/equatable.dart';

abstract class UsageEvent extends Equatable {
  const UsageEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ط¨ظٹط§ظ†ط§طھ ط§ظ„ط§ط³طھط®ط¯ط§ظ… ط¹ظ†ط¯ ظپطھط­ ط§ظ„طµظپط­ط©
class UsageStarted extends UsageEvent {
  const UsageStarted();
}

/// ط§ط®طھظٹط§ط± ط¨ط§ظ‚ط© ظ…ظ† ظ‚ط§ط¦ظ…ط© ط§ظ„ط¨ط§ظ‚ط§طھ
class UsagePlanSelected extends UsageEvent {
  final int index;
  const UsagePlanSelected(this.index);
  @override
  List<Object?> get props => [index];
}

/// طھط·ط¨ظٹظ‚ ط§ظ„ط¨ط§ظ‚ط© ط§ظ„ظ…ط®طھط§ط±ط©
class UsagePlanApplied extends UsageEvent {
  const UsagePlanApplied();
}


