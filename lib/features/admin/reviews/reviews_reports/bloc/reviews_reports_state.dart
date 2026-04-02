import 'package:equatable/equatable.dart';
import '../domain/entities/review_entity.dart';
import '../domain/entities/report_entity.dart';

enum ReviewsReportsStatus { initial, loading, ready, failure }

class ReviewsReportsState extends Equatable {
  final ReviewsReportsStatus status;
  final int tab;
  final List<ReviewEntity> reviews;
  final List<ReportEntity> reports;
  final String? error;

  const ReviewsReportsState({
    required this.status,
    required this.tab,
    required this.reviews,
    required this.reports,
    required this.error,
  });

  factory ReviewsReportsState.initial() => const ReviewsReportsState(
        status: ReviewsReportsStatus.initial,
        tab: 0,
        reviews: [],
        reports: [],
        error: null,
      );

  ReviewsReportsState copyWith({
    ReviewsReportsStatus? status,
    int? tab,
    List<ReviewEntity>? reviews,
    List<ReportEntity>? reports,
    String? error,
  }) =>
      ReviewsReportsState(
        status: status ?? this.status,
        tab: tab ?? this.tab,
        reviews: reviews ?? this.reviews,
        reports: reports ?? this.reports,
        error: error,
      );

  @override
  List<Object?> get props => [status, tab, reviews, reports, error];
}


