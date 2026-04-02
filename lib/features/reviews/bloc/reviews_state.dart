import 'package:equatable/equatable.dart';
import '../domain/entities/review.dart';
import '../domain/entities/reviews_summary.dart';

class ReviewsState extends Equatable {
  final ReviewsSummary? summary;
  final List<Review> reviews;
  final int selectedFilterIndex;
  final bool isLoading;
  final String? error;

  const ReviewsState({
    this.summary,
    this.reviews = const [],
    this.selectedFilterIndex = 0,
    this.isLoading = false,
    this.error,
  });

  ReviewsState copyWith({
    ReviewsSummary? summary,
    List<Review>? reviews,
    int? selectedFilterIndex,
    bool? isLoading,
    String? error,
  }) {
    return ReviewsState(
      summary: summary ?? this.summary,
      reviews: reviews ?? this.reviews,
      selectedFilterIndex:
          selectedFilterIndex ?? this.selectedFilterIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [summary, reviews, selectedFilterIndex, isLoading, error];
}
