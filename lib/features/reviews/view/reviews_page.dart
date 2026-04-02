import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reviews_bloc.dart';
import '../bloc/reviews_event.dart';
import '../bloc/reviews_state.dart';
import '../data/repos/reviews_repo_dummy.dart';
import '../data/sources/reviews_firebase_source.dart';
import '../domain/usecases/get_reviews_usecase.dart';
import '../../../core/i18n/app_i18n.dart';
import '../widgets/rating_bar_row.dart';
import '../widgets/review_card.dart';
import '../widgets/reviews_filter_chip.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    final source = ReviewsFirebaseSource();
    final repo = ReviewsRepoDummy(source);
    return BlocProvider(
      create: (_) => ReviewsBloc(
        getReviewsUseCase: GetReviewsUseCase(repo),
      )..add(const ReviewsStarted()),
      child: const ReviewsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ReviewsBloc, ReviewsState>(
          builder: (context, state) {
            if (state.isLoading && state.summary == null) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.t('reviewsPageTitle'),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Overall Rating Card
                    if (state.summary != null)
                      _OverallRatingCard(summary: state.summary!),
                    const SizedBox(height: 24),
                    // Filter
                    Text(context.t('reviewsFilter'),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        ReviewsFilterChip(
                          label: context.t('reviewsAll'),
                          index: 0,
                          selectedIndex:
                              state.selectedFilterIndex,
                          onTap: () =>
                              context.read<ReviewsBloc>().add(
                                  const ReviewsFilterChanged(0)),
                        ),
                        ReviewsFilterChip(
                          label: context.t('reviewsMyReviews'),
                          index: 1,
                          selectedIndex:
                              state.selectedFilterIndex,
                          onTap: () =>
                              context.read<ReviewsBloc>().add(
                                  const ReviewsFilterChanged(1)),
                        ),
                        ReviewsFilterChip(
                          label: context.t('reviewsMostRecent'),
                          index: 2,
                          selectedIndex:
                              state.selectedFilterIndex,
                          onTap: () =>
                              context.read<ReviewsBloc>().add(
                                  const ReviewsFilterChanged(2)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(context.t('reviewsRecent'),
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 16),
                    if (state.isLoading)
                      const Center(
                          child: CircularProgressIndicator())
                    else
                      ...state.reviews
                          .map((r) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 14),
                                child: ReviewCard(review: r),
                              )),
                    Text(
                      context.t('reviewsTip'),
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OverallRatingCard extends StatelessWidget {
  final summary;
  const _OverallRatingCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryTint8,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t('reviewsOverall'),
              style:
                  TextStyle(fontSize: 14, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                summary.overallRating.toStringAsFixed(1),
                style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                        5,
                        (i) => const Icon(Icons.star,
                            size: 18,
                            color: AppColors.amber)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${context.t('reviewsBasedOn')} ${summary.totalReviews} ${context.t('reviewsBasedOnSuffix')}',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...([5, 4, 3].map((star) {
            final count =
                (summary.ratingBreakdown[star] ?? 0) as int;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RatingBarRow(
                stars: star,
                count: count,
                total: summary.totalReviews as int,
              ),
            );
          })),
        ],
      ),
    );
  }
}
