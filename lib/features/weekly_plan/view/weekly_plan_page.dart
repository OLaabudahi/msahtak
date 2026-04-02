import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weekly_plan_bloc.dart';
import '../bloc/weekly_plan_event.dart';
import '../bloc/weekly_plan_state.dart';
import '../data/repos/weekly_plan_repo_dummy.dart';
import '../data/sources/weekly_plan_firebase_source.dart';
import '../domain/usecases/activate_plan_usecase.dart';
import '../domain/usecases/get_weekly_plan_usecase.dart';
import '../../../core/i18n/app_i18n.dart';
import '../widgets/feature_list_card.dart';
import '../widgets/plan_card.dart';

class WeeklyPlanPage extends StatelessWidget {
  const WeeklyPlanPage({super.key});

  /// إنشاء الصفحة مع BLoC خاص بها
  static Widget withBloc() {
    final source = WeeklyPlanFirebaseSource();
    final repo = WeeklyPlanRepoDummy(source);
    return BlocProvider(
      create: (_) => WeeklyPlanBloc(
        getWeeklyPlanUseCase: GetWeeklyPlanUseCase(repo),
        activatePlanUseCase: ActivatePlanUseCase(repo),
      )..add(const WeeklyPlanStarted()),
      child: const WeeklyPlanPage(),
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
              color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('weeklyPlanTitle'),
          style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<WeeklyPlanBloc, WeeklyPlanState>(
        listenWhen: (p, c) => c.isActivated && !p.isActivated,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t('weeklyPlanActivated')),
              backgroundColor: AppColors.amber,
            ),
          );
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator());
          }
          final plan = state.planDetails;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t('weeklyPlanSaveMore'),
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  context.t('weeklyPlanSubtitle'),
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 14),
                // Hub Dropdown
                _HubDropdown(
                  hubs: state.hubs,
                  selectedId: state.selectedHubId,
                ),
                const SizedBox(height: 16),
                if (plan != null) ...[
                  PlanCard(pricePerWeek: plan.pricePerWeek),
                  const SizedBox(height: 20),
                  Text(
                    context.t('weeklyPlanWhatYouGet'),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  FeatureListCard(features: plan.features),
                  const SizedBox(height: 12),
                  Text(
                    plan.tip,
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: 11),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: state.isActivating
                        ? null
                        : () => context.read<WeeklyPlanBloc>().add(
                            const WeeklyPlanActivatePressed()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: state.isActivating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black))
                        : Text(
                            context.t('weeklyPlanActivate'),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HubDropdown extends StatelessWidget {
  final List hubs;
  final String selectedId;

  const _HubDropdown(
      {required this.hubs, required this.selectedId});

  @override
  Widget build(BuildContext context) {
    if (hubs.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderMedium),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black, fontSize: 14),
          items: hubs
              .map((h) => DropdownMenuItem<String>(
                    value: h.id as String,
                    child: Text(h.name as String),
                  ))
              .toList(),
          onChanged: (id) {
            if (id != null) {
              context
                  .read<WeeklyPlanBloc>()
                  .add(WeeklyPlanHubChanged(id));
            }
          },
        ),
      ),
    );
  }
}
