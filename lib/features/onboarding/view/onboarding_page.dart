import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_spacing.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../home/view/home_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/check_option_card.dart';
import '../widgets/info_banner.dart';
import '../widgets/insights_card.dart';
import '../widgets/select_pill.dart';
import '../widgets/step_indicator.dart';
import '../widgets/switch_tile.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
  static Widget withBloc() {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const OnboardingPage(),
    );
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(int index) {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (p, c) => p.stepIndex != c.stepIndex || p.goHome != c.goHome,
      listener: (context, state) {
        if (state.goHome) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage.withBloc()),
          );
          return;
        }
        _animateTo(state.stepIndex);
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              final bloc = context.read<OnboardingBloc>();
              final isLast = state.stepIndex == state.totalSteps - 1;
              final buttonText = isLast ? context.t('goToHome') : context.t('next');

              return Column(
                children: [
                  Padding(
                    padding: AppSpacing.screen,
                    child: _TopHeader(
                      onSkip: () => bloc.add(const OnboardingSkipPressed()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _StepRow(
                      activeIndex: state.stepIndex,
                      total: state.totalSteps,
                      stepLabel: state.stepLabel,
                      onDotTap: (i) => bloc.add(OnboardingGoToStep(i)),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        if (index != state.stepIndex) {
                          bloc.add(OnboardingGoToStepFromSwipe(index));
                        }
                      },
                      children: [
                        _Step1Content(state: state),
                        _Step2Content(state: state),
                        _Step3Content(state: state),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            bloc.add(const OnboardingNextPressed()),
                        child: Text(buttonText),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopHeader({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppAssets.logo, height: 46, fit: BoxFit.contain),
        const Spacer(),
        GestureDetector(
          onTap: onSkip,
          child: Text(context.t('skip'), style: AppTextStyles.link),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final int activeIndex;
  final int total;
  final String stepLabel;
  final ValueChanged<int> onDotTap;

  const _StepRow({
    required this.activeIndex,
    required this.total,
    required this.stepLabel,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StepIndicator(
          activeIndex: activeIndex,
          count: total,
          onDotTap: onDotTap,
        ),
        AppSpacing.hLg,
        Text(stepLabel, style: AppTextStyles.step),
      ],
    );
  }
}

class _Step1Content extends StatelessWidget {
  final OnboardingState state;
  const _Step1Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();
    bool isSelected(WhyChoose o) => state.selectedWhy.contains(o);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.vLg,
          Text(context.t('findPerfectWorkspace'), style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text(context.t('bookStudySpaces'), style: AppTextStyles.body),
          AppSpacing.vLg,
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: Image.asset(AppAssets.welcome, fit: BoxFit.contain),
            ),
          ),
          AppSpacing.vLg,
          Text(context.t('clearInfoBeforeBook'), style: AppTextStyles.sectionTitle),
          AppSpacing.vXs,
          Text(context.t('clearInfoSubtitle'), style: AppTextStyles.body),
          AppSpacing.vLg,
          Text(context.t('whyMashtak'), style: AppTextStyles.sectionTitle),
          AppSpacing.vMd,
          CheckOptionCard(
            title: context.t('bookWithConfidence'),
            subtitle: context.t('bookWithConfidenceSubtitle'),
            selected: isSelected(WhyChoose.confidence),
            onTap: () =>
                bloc.add(const OnboardingToggleWhy(WhyChoose.confidence)),
          ),
          AppSpacing.vMd,
          CheckOptionCard(
            title: context.t('smartSuggestions'),
            subtitle: context.t('smartSuggestionsSubtitle'),
            selected: isSelected(WhyChoose.smartSuggestions),
            onTap: () =>
                bloc.add(const OnboardingToggleWhy(WhyChoose.smartSuggestions)),
          ),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}

class _Step2Content extends StatelessWidget {
  final OnboardingState state;
  const _Step2Content({required this.state});

  String _purposeLabel(BuildContext context, BookingPurpose p) {
    switch (p) {
      case BookingPurpose.study:
        return context.t('purposeStudy');
      case BookingPurpose.deepFocus:
        return context.t('purposeDeepFocus');
      case BookingPurpose.meetings:
        return context.t('purposeMeetings');
      case BookingPurpose.teamWork:
        return context.t('purposeTeamWork');
      case BookingPurpose.callsInterviews:
        return context.t('purposeCallsInterviews');
      case BookingPurpose.creative:
        return context.t('purposeCreative');
    }
  }

  String _matterLabel(BuildContext context, WhatMatters m) {
    switch (m) {
      case WhatMatters.quiet:
        return context.t('matterQuiet');
      case WhatMatters.fastWifi:
        return context.t('matterFastWifi');
      case WhatMatters.budgetFriendly:
        return context.t('matterBudgetFriendly');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.vLg,
          Text(context.t('whatAreYouBookingFor'), style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text(context.t('selectAllThatApply'), style: AppTextStyles.body),
          AppSpacing.vLg,
          Row(
            children: [
              Text(context.t('mainPurpose'), style: AppTextStyles.sectionTitle),
              const Spacer(),
              Text(
                context.t('selectMultiple'),
                style: AppTextStyles.caption.copyWith(color: AppColors.subtext),
              ),
            ],
          ),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: BookingPurpose.values.map((p) {
              final selected = state.selectedPurposes.contains(p);
              return SelectPill(
                text: _purposeLabel(context, p),
                selected: selected,
                onTap: () => bloc.add(OnboardingTogglePurpose(p)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          Text(context.t('whatMattersMost'), style: AppTextStyles.sectionTitle),
          AppSpacing.vXs,
          Text(context.t('whatMattersOptional'), style: AppTextStyles.body),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: WhatMatters.values.map((m) {
              final selected = state.selectedMatters.contains(m);
              return SelectPill(
                text: _matterLabel(context, m),
                selected: selected,
                onTap: () => bloc.add(OnboardingToggleMatter(m)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          InsightsCard(
            title: context.t('youllSeeInsightsLike'),
            chips: [
              context.t('insightBestStudy'),
              context.t('insightQuietInternet'),
              context.t('insightWeeklySaves'),
            ],
          ),
          AppSpacing.vMd,
          InfoBanner(
            iconText: context.t('ai'),
            title: context.t('aiWillUseYourChoices'),
            subtitle: context.t('aiSubtitle'),
            footnote: context.t('aiFootnote'),
          ),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}

class _Step3Content extends StatelessWidget {
  final OnboardingState state;
  const _Step3Content({required this.state});

  String _timingLabel(BuildContext context, ReminderTiming t) {
    switch (t) {
      case ReminderTiming.min30:
        return context.t('timing30min');
      case ReminderTiming.hour1:
        return context.t('timing1hour');
      case ReminderTiming.sameDay9am:
        return context.t('timingSameDay');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.vLg,
          Text(context.t('stayUpdated'), style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text(context.t('chooseAlerts'), style: AppTextStyles.body),
          AppSpacing.vLg,
          Text(context.t('bookingAlerts'), style: AppTextStyles.sectionTitle),
          AppSpacing.vMd,
          Card(
            color: AppColors.surface2,
            child: Padding(
              padding: AppSpacing.card,
              child: Column(
                children: [
                  SwitchTile(
                    title: context.t('bookingApproved'),
                    subtitle: context.t('bookingApprovedSubtitle'),
                    value: state.bookingApprovedAlert,
                    onChanged: (_) =>
                        bloc.add(const OnboardingToggleApprovedAlert()),
                  ),
                  AppSpacing.vMd,
                  SwitchTile(
                    title: context.t('bookingRejected'),
                    subtitle: context.t('bookingRejectedSubtitle'),
                    value: state.bookingRejectedAlert,
                    onChanged: (_) =>
                        bloc.add(const OnboardingToggleRejectedAlert()),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vLg,
          SwitchTile(
            title: context.t('reminderBeforeBooking'),
            subtitle: context.t('reminderBeforeBookingSubtitle'),
            value: state.reminderBeforeBooking,
            onChanged: (_) =>
                bloc.add(const OnboardingToggleReminderBeforeBooking()),
            withDivider: true,
          ),
          AppSpacing.vSm,
          Row(
            children: [
              Text(context.t('reminderTiming'), style: AppTextStyles.sectionTitle),
              AppSpacing.hSm,
              Text(
                context.t('optionalLabel'),
                style: AppTextStyles.caption.copyWith(color: AppColors.subtext),
              ),
            ],
          ),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ReminderTiming.values.map((t) {
              final selected = state.reminderTiming == t;
              return SelectPill(
                text: _timingLabel(context, t),
                selected: selected,
                onTap: () => bloc.add(OnboardingSelectReminderTiming(t)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          InfoBanner(
            leadingIcon: Icons.notifications_none_rounded,
            title: context.t('notificationsHelp'),
            subtitle: context.t('notificationsSubtitle'),
            footnote: context.t('notificationsFootnote'),
          ),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}


