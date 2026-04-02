import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../space_details/view/space_details_page.dart';
import '../bloc/best_for_you_bloc.dart';
import '../bloc/best_for_you_event.dart';
import '../bloc/best_for_you_state.dart';
import '../data/repos/best_for_you_repo_dummy.dart';
import '../data/sources/best_for_you_firebase_source.dart';
import '../domain/entities/best_for_you_space.dart';
import '../domain/usecases/get_best_for_you_usecase.dart';
import '../domain/usecases/get_top_rated_nearby_usecase.dart';
import '../widgets/fit_score_card.dart';
import '../widgets/heads_up_card.dart';

class BestForYouPage extends StatelessWidget {
  const BestForYouPage({super.key});

  static Widget withBloc() {
    final source = BestForYouFirebaseSource();
    final repo = BestForYouRepoDummy(source);
    return BlocProvider(
      create: (_) => BestForYouBloc(
        getBestForYouUseCase: GetBestForYouUseCase(repo),
        getTopRatedNearbyUseCase: GetTopRatedNearbyUseCase(repo),
      )..add(const BestForYouStarted()),
      child: const BestForYouPage(),
    );
  }

  void _openSpaceDetails(BuildContext context, String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpaceDetailsPage.withBloc(spaceId: spaceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Best For You',
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<BestForYouBloc, BestForYouState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── قسم أعلى 5 مساحات قريبة ───
                const Text(
                  'Top Rated Spaces Near You',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Highest-rated spaces within 100 m of your location',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 14),

                if (state.topSpaces.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No spaces found nearby.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ...state.topSpaces.map(
                    (space) => _SpaceListItem(
                      space: space,
                      onView: () => _openSpaceDetails(context, space.id),
                    ),
                  ),

                const SizedBox(height: 24),

                // ─── قسم الهدف وFit Score ───
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Best Match for Your Goal',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                _GoalDropdown(
                  goals: state.goals,
                  selectedGoal: state.selectedGoal,
                ),
                const SizedBox(height: 12),
                if (state.fitScore != null) ...[
                  FitScoreCard(
                    fitScore: state.fitScore!,
                    goal: state.selectedGoal,
                  ),
                  const SizedBox(height: 14),
                  HeadsUpCard(message: state.fitScore!.headsUp),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// عنصر مساحة واحدة في القائمة — نفس تصميم SpaceResultCard
class _SpaceListItem extends StatelessWidget {
  final BestForYouSpace space;
  final VoidCallback onView;

  const _SpaceListItem({required this.space, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: space.imageUrl != null
                            ? Image.network(
                                space.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _placeholder(),
                              )
                            : _placeholder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            space.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            space.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 6),
                          if (space.distance != '--') ...[
                            Text(
                              space.distance,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                          ],
                          Text(
                            '₪${space.pricePerDay}/day',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.ratingBadgeBg,
                      ),
                      child: Row(
                        children: [
                          Text(
                            space.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnSecondary,
                    foregroundColor: AppColors.btnSecondaryText,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  child: const Text('View',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.surface,
        child: const Icon(Icons.image, size: 28),
      );
}

class _GoalDropdown extends StatelessWidget {
  final List<String> goals;
  final String selectedGoal;

  const _GoalDropdown({required this.goals, required this.selectedGoal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderMedium),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGoal,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          items: goals.map((g) {
            return DropdownMenuItem(value: g, child: Text(g));
          }).toList(),
          onChanged: (goal) {
            if (goal != null) {
              context
                  .read<BestForYouBloc>()
                  .add(BestForYouGoalChanged(goal));
            }
          },
        ),
      ),
    );
  }
}
