import 'package:equatable/equatable.dart';

abstract class BestForYouEvent extends Equatable {
  const BestForYouEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ط§ظ„ط¨ظٹط§ظ†ط§طھ ط¹ظ†ط¯ ظپطھط­ ط§ظ„طµظپط­ط© ط¨ط§ظ„ظ‡ط¯ظپ ط§ظ„ط§ظپطھط±ط§ط¶ظٹ
class BestForYouStarted extends BestForYouEvent {
  const BestForYouStarted();
}

/// طھط؛ظٹظٹط± ط§ظ„ظ‡ط¯ظپ ط§ظ„ظ…ط®طھط§ط± (Study / Work / Meeting / Relax)
class BestForYouGoalChanged extends BestForYouEvent {
  final String goal;
  const BestForYouGoalChanged(this.goal);
  @override
  List<Object?> get props => [goal];
}

/// ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ ط²ط± "Continue to Booking"
class BestForYouContinuePressed extends BestForYouEvent {
  const BestForYouContinuePressed();
}


