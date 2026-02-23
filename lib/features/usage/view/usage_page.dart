import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/usage_bloc.dart';
import '../bloc/usage_event.dart';
import '../bloc/usage_state.dart';
import '../data/repos/usage_repo_dummy.dart';
import '../data/sources/usage_remote_source.dart';
import '../domain/usecases/apply_plan_usecase.dart';
import '../domain/usecases/get_usage_usecase.dart';
import '../widgets/plan_item_tile.dart';
import '../widgets/usage_stats_card.dart';

class UsagePage extends StatelessWidget {
  const UsagePage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    final source = FakeUsageSource();
    final repo = UsageRepoDummy(source);
    return BlocProvider(
      create: (_) => UsageBloc(
        getUsageUseCase: GetUsageUseCase(repo),
        applyPlanUseCase: ApplyPlanUseCase(repo),
      )..add(const UsageStarted()),
      child: const UsagePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<UsageBloc, UsageState>(
          listenWhen: (p, c) => c.isApplied && !p.isApplied,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plan applied successfully!'),
                backgroundColor: AppColors.amber,
              ),
            );
          },
          builder: (context, state) {
            if (state.isLoading) {
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
                        const Text('Your Usage',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 38),
                      child: Text(
                        'Based on your last 30 days',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.stats != null)
                      UsageStatsCard(stats: state.stats!),
                    const SizedBox(height: 28),
                    const Text('Plan Optimizer',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    const Text('Compare plans',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    const SizedBox(height: 16),
                    // Plans List
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: List.generate(
                            state.plans.length, (i) {
                          return PlanItemTile(
                            plan: state.plans[i],
                            isSelected:
                                state.selectedPlanIndex == i,
                            onTap: () =>
                                context.read<UsageBloc>().add(
                                    UsagePlanSelected(i)),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Recommendation
                    if (state.stats != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text('Recommendation',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 6),
                            Text(
                              state.stats!.recommendation,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.isApplying
                            ? null
                            : () => context
                                .read<UsageBloc>()
                                .add(const UsagePlanApplied()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(26)),
                          elevation: 0,
                        ),
                        child: state.isApplying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black))
                            : Text(
                                state.plans.isNotEmpty
                                    ? 'Apply ${state.plans[state.selectedPlanIndex].name} Plan'
                                    : 'Apply Weekly Plan',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                      ),
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
