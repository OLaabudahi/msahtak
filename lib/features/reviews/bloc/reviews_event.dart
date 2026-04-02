import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل التقييمات عند فتح الصفحة
class ReviewsStarted extends ReviewsEvent {
  const ReviewsStarted();
}

/// تغيير الفلتر المختار (all / mine / recent)
class ReviewsFilterChanged extends ReviewsEvent {
  final int filterIndex; // 0=All, 1=My reviews, 2=Most recent
  const ReviewsFilterChanged(this.filterIndex);
  @override
  List<Object?> get props => [filterIndex];
}
