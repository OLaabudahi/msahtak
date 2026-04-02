part of 'onboarding_bloc.dart';

enum BookingPurpose {
  study,
  deepFocus,
  meetings,
  teamWork,
  callsInterviews,
  creative,
}

enum WhatMatters { quiet, fastWifi, budgetFriendly }

enum ReminderTiming { min30, hour1, sameDay9am }

enum WhyChoose { confidence, smartSuggestions }

class OnboardingState extends Equatable {
  final int stepIndex;
  final int totalSteps;

  final Set<BookingPurpose> selectedPurposes;
  final Set<WhatMatters> selectedMatters;
  final Set<WhyChoose> selectedWhy;

  final bool bookingApprovedAlert;
  final bool bookingRejectedAlert;
  final bool reminderBeforeBooking;
  final ReminderTiming reminderTiming;

  final bool goHome;

  const OnboardingState({
    required this.stepIndex,
    required this.totalSteps,
    required this.selectedPurposes,
    required this.selectedMatters,
    required this.selectedWhy,
    required this.bookingApprovedAlert,
    required this.bookingRejectedAlert,
    required this.reminderBeforeBooking,
    required this.reminderTiming,
    required this.goHome,
  });

  factory OnboardingState.initial() => OnboardingState(
    stepIndex: 0,
    totalSteps: 3,
    selectedPurposes: {BookingPurpose.study},
    selectedMatters: {WhatMatters.quiet},
    selectedWhy: {WhyChoose.confidence, WhyChoose.smartSuggestions},
    bookingApprovedAlert: true,
    bookingRejectedAlert: true,
    reminderBeforeBooking: false,
    reminderTiming: ReminderTiming.min30,
    goHome: false,
  );

  String get stepLabel => 'Step ${stepIndex + 1} of $totalSteps';

  OnboardingState copyWith({
    int? stepIndex,
    int? totalSteps,
    Set<BookingPurpose>? selectedPurposes,
    Set<WhatMatters>? selectedMatters,
    Set<WhyChoose>? selectedWhy,
    bool? bookingApprovedAlert,
    bool? bookingRejectedAlert,
    bool? reminderBeforeBooking,
    ReminderTiming? reminderTiming,
    bool? goHome,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      totalSteps: totalSteps ?? this.totalSteps,
      selectedPurposes: selectedPurposes ?? this.selectedPurposes,
      selectedMatters: selectedMatters ?? this.selectedMatters,
      selectedWhy: selectedWhy ?? this.selectedWhy,
      bookingApprovedAlert: bookingApprovedAlert ?? this.bookingApprovedAlert,
      bookingRejectedAlert: bookingRejectedAlert ?? this.bookingRejectedAlert,
      reminderBeforeBooking:
          reminderBeforeBooking ?? this.reminderBeforeBooking,
      reminderTiming: reminderTiming ?? this.reminderTiming,
      goHome: goHome ?? this.goHome,
    );
  }

  @override
  List<Object?> get props => [
    stepIndex,
    totalSteps,
    selectedPurposes,
    selectedMatters,
    selectedWhy,
    bookingApprovedAlert,
    bookingRejectedAlert,
    reminderBeforeBooking,
    reminderTiming,
    goHome,
  ];
}


