import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ط§ظ„طھظ‚ظٹظٹظ…ط§طھ ط¹ظ†ط¯ ظپطھط­ ط§ظ„طµظپط­ط©
class ReviewsStarted extends ReviewsEvent {
  const ReviewsStarted();
}

/// طھط؛ظٹظٹط± ط§ظ„ظپظ„طھط± ط§ظ„ظ…ط®طھط§ط± (all / mine / recent)
class ReviewsFilterChanged extends ReviewsEvent {
  final int filterIndex; // 0=All, 1=My reviews, 2=Most recent
  const ReviewsFilterChanged(this.filterIndex);
  @override
  List<Object?> get props => [filterIndex];
}


