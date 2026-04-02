import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState.initial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingNextPressed>(_onNext);
    on<OnboardingSkipPressed>(_onSkip);
    on<OnboardingGoToStep>(_onGoToStep);

    on<OnboardingToggleWhy>(_onToggleWhy);

    on<OnboardingTogglePurpose>(_onTogglePurpose);
    on<OnboardingToggleMatter>(_onToggleMatter);

    on<OnboardingToggleApprovedAlert>(_onToggleApproved);
    on<OnboardingToggleRejectedAlert>(_onToggleRejected);
    on<OnboardingToggleReminderBeforeBooking>(_onToggleReminder);
    on<OnboardingSelectReminderTiming>(_onSelectTiming);
    on<OnboardingGoToStepFromSwipe>(_onGoToStepFromSwipe);
  }

  void _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(stepIndex: 0, goHome: false));
  }

  void _onGoToStepFromSwipe(
    OnboardingGoToStepFromSwipe event,
    Emitter<OnboardingState> emit,
  ) {
    final idx = event.index.clamp(0, state.totalSteps - 1);
    emit(state.copyWith(stepIndex: idx));
  }

  void _onNext(OnboardingNextPressed event, Emitter<OnboardingState> emit) {
    final bool isLast = state.stepIndex == state.totalSteps - 1;
    if (isLast) {
      emit(state.copyWith(goHome: true));
      return;
    }
    emit(state.copyWith(stepIndex: state.stepIndex + 1));
  }

  void _onSkip(OnboardingSkipPressed event, Emitter<OnboardingState> emit) {
    final bool isLast = state.stepIndex == state.totalSteps - 1;
    if (isLast) {
      emit(state.copyWith(goHome: true));
      return;
    }
    emit(state.copyWith(stepIndex: state.totalSteps - 1));
  }

  void _onGoToStep(OnboardingGoToStep event, Emitter<OnboardingState> emit) {
    final idx = event.index.clamp(0, state.totalSteps - 1);
    emit(state.copyWith(stepIndex: idx));
  }

  void _onToggleWhy(OnboardingToggleWhy event, Emitter<OnboardingState> emit) {
    final next = Set<WhyChoose>.from(state.selectedWhy);
    if (next.contains(event.option)) {
      next.remove(event.option);
    } else {
      next.add(event.option);
    }
    emit(state.copyWith(selectedWhy: next));
  }

  void _onTogglePurpose(
    OnboardingTogglePurpose event,
    Emitter<OnboardingState> emit,
  ) {
    final next = Set<BookingPurpose>.from(state.selectedPurposes);
    if (next.contains(event.purpose)) {
      next.remove(event.purpose);
    } else {
      next.add(event.purpose);
    }
    emit(state.copyWith(selectedPurposes: next));
  }

  void _onToggleMatter(
    OnboardingToggleMatter event,
    Emitter<OnboardingState> emit,
  ) {
    final next = Set<WhatMatters>.from(state.selectedMatters);
    if (next.contains(event.matter)) {
      next.remove(event.matter);
    } else {
      next.add(event.matter);
    }
    emit(state.copyWith(selectedMatters: next));
  }

  void _onToggleApproved(
    OnboardingToggleApprovedAlert event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(bookingApprovedAlert: !state.bookingApprovedAlert));
  }

  void _onToggleRejected(
    OnboardingToggleRejectedAlert event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(bookingRejectedAlert: !state.bookingRejectedAlert));
  }

  void _onToggleReminder(
    OnboardingToggleReminderBeforeBooking event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(reminderBeforeBooking: !state.reminderBeforeBooking));
  }

  void _onSelectTiming(
    OnboardingSelectReminderTiming event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(reminderTiming: event.timing));
  }
}
