import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_spacing.dart';
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
            MaterialPageRoute(builder: (_) => const OnboardingHomePage()),
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
              final buttonText = isLast ? 'Go To Home' : 'Next';

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
                        onPressed: () => bloc.add(const OnboardingNextPressed()),
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
          child: Text('Skip', style: AppTextStyles.link),
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
        StepIndicator(activeIndex: activeIndex, count: total, onDotTap: onDotTap),
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
          const Text('Find your perfect workspace', style: AppTextStyles.h1),
          AppSpacing.vSm,
          const Text(
            'Book work and study spaces with clear\nprices, real insights, and flexible plans.',
            style: AppTextStyles.body,
          ),
          AppSpacing.vLg,
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: Image.asset(AppAssets.welcome, fit: BoxFit.contain),
            ),
          ),
          AppSpacing.vLg,
          const Text('Clear info before you book', style: AppTextStyles.sectionTitle),
          AppSpacing.vXs,
          const Text('Price, rating, internet quality, and noise level.', style: AppTextStyles.body),
          AppSpacing.vLg,
          const Text('Why Mashtak', style: AppTextStyles.sectionTitle),
          AppSpacing.vMd,
          CheckOptionCard(
            title: 'Book with confidence',
            subtitle: 'Requests are approved before payment.',
            selected: isSelected(WhyChoose.confidence),
            onTap: () => bloc.add(const OnboardingToggleWhy(WhyChoose.confidence)),
          ),
          AppSpacing.vMd,
          CheckOptionCard(
            title: 'Smart suggestions',
            subtitle: 'AI highlights the best spaces for your goal.',
            selected: isSelected(WhyChoose.smartSuggestions),
            onTap: () => bloc.add(const OnboardingToggleWhy(WhyChoose.smartSuggestions)),
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

  String _purposeLabel(BookingPurpose p) {
    switch (p) {
      case BookingPurpose.study:
        return 'Study';
      case BookingPurpose.deepFocus:
        return 'Deep Focus';
      case BookingPurpose.meetings:
        return 'Meetings';
      case BookingPurpose.teamWork:
        return 'Team Work';
      case BookingPurpose.callsInterviews:
        return 'Calls / Interviews';
      case BookingPurpose.creative:
        return 'Creative';
    }
  }

  String _matterLabel(WhatMatters m) {
    switch (m) {
      case WhatMatters.quiet:
        return 'Quiet';
      case WhatMatters.fastWifi:
        return 'Fast Wi-Fi';
      case WhatMatters.budgetFriendly:
        return 'Budget friendly';
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
          const Text('What are you booking for?', style: AppTextStyles.h1),
          AppSpacing.vSm,
          const Text('Select all that apply. We\'ll tailor\nspaces to your needs.', style: AppTextStyles.body),
          AppSpacing.vLg,
          Row(
            children: [
              const Text('Main purpose', style: AppTextStyles.sectionTitle),
              const Spacer(),
              Text('Select multiple', style: AppTextStyles.caption.copyWith(color: AppColors.subtext)),
            ],
          ),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: BookingPurpose.values.map((p) {
              final selected = state.selectedPurposes.contains(p);
              return SelectPill(
                text: _purposeLabel(p),
                selected: selected,
                onTap: () => bloc.add(OnboardingTogglePurpose(p)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          const Text('What matters most?', style: AppTextStyles.sectionTitle),
          AppSpacing.vXs,
          const Text('Optional — helps us rank results better.', style: AppTextStyles.body),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: WhatMatters.values.map((m) {
              final selected = state.selectedMatters.contains(m);
              return SelectPill(
                text: _matterLabel(m),
                selected: selected,
                onTap: () => bloc.add(OnboardingToggleMatter(m)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          const InsightsCard(
            title: 'You\'ll see insights like',
            chips: ['Best for study', 'Quiet + strong internet', 'Weekly saves more'],
          ),
          AppSpacing.vMd,
          const InfoBanner(
            iconText: 'AI',
            title: 'AI will use your choices',
            subtitle: 'Smarter suggestions + review summaries\n(not a chatbot).',
            footnote: 'You can change these later in Settings.',
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

  String _timingLabel(ReminderTiming t) {
    switch (t) {
      case ReminderTiming.min30:
        return '30 min';
      case ReminderTiming.hour1:
        return '1 hour';
      case ReminderTiming.sameDay9am:
        return 'Same day (9 AM)';
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
          const Text('Stay updated', style: AppTextStyles.h1),
          AppSpacing.vSm,
          const Text('Choose the alerts you want.\nYou can change them anytime.', style: AppTextStyles.body),
          AppSpacing.vLg,
          const Text('Booking alerts', style: AppTextStyles.sectionTitle),
          AppSpacing.vMd,
          Card(
            color: AppColors.surface2,
            child: Padding(
              padding: AppSpacing.card,
              child: Column(
                children: [
                  SwitchTile(
                    title: 'Booking approved',
                    subtitle: 'When a space confirms your request.',
                    value: state.bookingApprovedAlert,
                    onChanged: (_) => bloc.add(const OnboardingToggleApprovedAlert()),
                  ),
                  AppSpacing.vMd,
                  SwitchTile(
                    title: 'Booking rejected',
                    subtitle: 'So you can quickly pick another option.',
                    value: state.bookingRejectedAlert,
                    onChanged: (_) => bloc.add(const OnboardingToggleRejectedAlert()),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vLg,
          SwitchTile(
            title: 'Reminder before booking',
            subtitle: 'A quick reminder before your reserved time.',
            value: state.reminderBeforeBooking,
            onChanged: (_) => bloc.add(const OnboardingToggleReminderBeforeBooking()),
            withDivider: true,
          ),
          AppSpacing.vSm,
          Row(
            children: [
              const Text('Reminder timing', style: AppTextStyles.sectionTitle),
              AppSpacing.hSm,
              Text('(Optional)', style: AppTextStyles.caption.copyWith(color: AppColors.subtext)),
            ],
          ),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ReminderTiming.values.map((t) {
              final selected = state.reminderTiming == t;
              return SelectPill(
                text: _timingLabel(t),
                selected: selected,
                onTap: () => bloc.add(OnboardingSelectReminderTiming(t)),
              );
            }).toList(),
          ),
          AppSpacing.vLg,
          const InfoBanner(
            leadingIcon: Icons.notifications_none_rounded,
            title: 'Notifications help you trust bookings',
            subtitle: 'Get approvals, rejections, and reminders\nright on time.',
            footnote: 'Tip: You\'ll still see booking status inside the Bookings tab.',
          ),
          AppSpacing.vXl,
        ],
      ),
    );
  }
}
