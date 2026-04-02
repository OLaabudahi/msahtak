import 'package:equatable/equatable.dart';

sealed class ReviewsReportsEvent extends Equatable {
  const ReviewsReportsEvent();
  @override
  List<Object?> get props => [];
}

class ReviewsReportsStarted extends ReviewsReportsEvent {
  const ReviewsReportsStarted();
}

class ReviewsReportsTabChanged extends ReviewsReportsEvent {
  final int tab; 
  const ReviewsReportsTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

class ReviewsReportsHidePressed extends ReviewsReportsEvent {
  final String reviewId;
  const ReviewsReportsHidePressed(this.reviewId);
  @override
  List<Object?> get props => [reviewId];
}

class ReviewsReportsReplyPressed extends ReviewsReportsEvent {
  final String reviewId;
  final String reply;
  const ReviewsReportsReplyPressed(this.reviewId, this.reply);
  @override
  List<Object?> get props => [reviewId, reply];
}
