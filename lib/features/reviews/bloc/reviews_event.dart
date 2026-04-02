import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();
  @override
  List<Object?> get props => [];
}


class ReviewsStarted extends ReviewsEvent {
  const ReviewsStarted();
}


class ReviewsFilterChanged extends ReviewsEvent {
  final int filterIndex; 
  const ReviewsFilterChanged(this.filterIndex);
  @override
  List<Object?> get props => [filterIndex];
}
