part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

class OnboardingSkipPressed extends OnboardingEvent {
  const OnboardingSkipPressed();
}

class OnboardingGoToStep extends OnboardingEvent {
  final int index;
  const OnboardingGoToStep(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingTogglePurpose extends OnboardingEvent {
  final BookingPurpose purpose;
  const OnboardingTogglePurpose(this.purpose);

  @override
  List<Object?> get props => [purpose];
}

class OnboardingToggleMatter extends OnboardingEvent {
  final WhatMatters matter;
  const OnboardingToggleMatter(this.matter);

  @override
  List<Object?> get props => [matter];
}

class OnboardingToggleWhy extends OnboardingEvent {
  final WhyChoose option;
  const OnboardingToggleWhy(this.option);

  @override
  List<Object?> get props => [option];
}

class OnboardingToggleApprovedAlert extends OnboardingEvent {
  const OnboardingToggleApprovedAlert();
}

class OnboardingToggleRejectedAlert extends OnboardingEvent {
  const OnboardingToggleRejectedAlert();
}

class OnboardingGoToStepFromSwipe extends OnboardingEvent {
  final int index;
  const OnboardingGoToStepFromSwipe(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingToggleReminderBeforeBooking extends OnboardingEvent {
  const OnboardingToggleReminderBeforeBooking();
}

class OnboardingSelectReminderTiming extends OnboardingEvent {
  final ReminderTiming timing;
  const OnboardingSelectReminderTiming(this.timing);

  @override
  List<Object?> get props => [timing];
}
