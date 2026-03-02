import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../space_details/view/space_details_page.dart';
import '../bloc/best_for_you_bloc.dart';
import '../bloc/best_for_you_event.dart';
import '../bloc/best_for_you_state.dart';
import '../data/repos/best_for_you_repo_dummy.dart';
import '../data/sources/best_for_you_firebase_source.dart';
import '../domain/usecases/get_best_for_you_usecase.dart';
import '../widgets/fit_score_card.dart';
import '../widgets/heads_up_card.dart';
import '../widgets/space_preview_card.dart';

class BestForYouPage extends StatelessWidget {
  const BestForYouPage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    final source = BestForYouFirebaseSource();
    final repo = BestForYouRepoDummy(source);
    return BlocProvider(
      create: (_) => BestForYouBloc(
        getBestForYouUseCase: GetBestForYouUseCase(repo),
      )..add(const BestForYouStarted()),
      child: const BestForYouPage(),
    );
  }

  /// التنقل إلى صفحة تفاصيل الفضاء
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
          icon: const Icon(Icons.arrow_back,
              color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Best For You',
          style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<BestForYouBloc, BestForYouState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a goal • See how well this place matches',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _GoalDropdown(
                  goals: state.goals,
                  selectedGoal: state.selectedGoal,
                ),
                const SizedBox(height: 14),
                if (state.isLoading)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ))
                else if (state.space != null) ...[
                  SpacePreviewCard(
                    space: state.space!,
                    onView: () =>
                        _openSpaceDetails(context, state.space!.id),
                  ),
                  const SizedBox(height: 14),
                  if (state.fitScore != null) ...[
                    FitScoreCard(
                      fitScore: state.fitScore!,
                      goal: state.selectedGoal,
                    ),
                    const SizedBox(height: 14),
                    HeadsUpCard(message: state.fitScore!.headsUp),
                  ],
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: state.space == null
                        ? null
                        : () => _openSpaceDetails(
                            context, state.space!.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue to Booking',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GoalDropdown extends StatelessWidget {
  final List<String> goals;
  final String selectedGoal;

  const _GoalDropdown(
      {required this.goals, required this.selectedGoal});

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
