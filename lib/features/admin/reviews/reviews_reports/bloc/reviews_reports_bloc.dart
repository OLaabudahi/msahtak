import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_reports_usecase.dart';
import '../domain/usecases/get_reviews_usecase.dart';
import '../domain/usecases/hide_review_usecase.dart';
import '../domain/usecases/reply_review_usecase.dart';
import 'reviews_reports_event.dart';
import 'reviews_reports_state.dart';

class ReviewsReportsBloc extends Bloc<ReviewsReportsEvent, ReviewsReportsState> {
  final GetReviewsUseCase getReviews;
  final GetReportsUseCase getReports;
  final HideReviewUseCase hideReview;
  final ReplyReviewUseCase replyReview;

  ReviewsReportsBloc({
    required this.getReviews,
    required this.getReports,
    required this.hideReview,
    required this.replyReview,
  }) : super(ReviewsReportsState.initial()) {
    on<ReviewsReportsStarted>(_onStarted);
    on<ReviewsReportsTabChanged>(_onTab);
    on<ReviewsReportsHidePressed>(_onHide);
    on<ReviewsReportsReplyPressed>(_onReply);
  }

  Future<void> _onStarted(ReviewsReportsStarted event, Emitter<ReviewsReportsState> emit) async {
    emit(state.copyWith(status: ReviewsReportsStatus.loading, error: null));
    try {
      final reviews = await getReviews();
      final reports = await getReports();
      emit(state.copyWith(status: ReviewsReportsStatus.ready, reviews: reviews, reports: reports));
    } catch (e) {
      emit(state.copyWith(status: ReviewsReportsStatus.failure, error: e.toString()));
    }
  }

  void _onTab(ReviewsReportsTabChanged event, Emitter<ReviewsReportsState> emit) => emit(state.copyWith(tab: event.tab));

  Future<void> _onHide(ReviewsReportsHidePressed event, Emitter<ReviewsReportsState> emit) async {
    await hideReview(reviewId: event.reviewId);
    add(const ReviewsReportsStarted());
  }

  Future<void> _onReply(ReviewsReportsReplyPressed event, Emitter<ReviewsReportsState> emit) async {
    await replyReview(reviewId: event.reviewId, reply: event.reply);
    add(const ReviewsReportsStarted());
  }
}


