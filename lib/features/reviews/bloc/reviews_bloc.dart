import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_reviews_usecase.dart';
import 'reviews_event.dart';
import 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final GetReviewsUseCase getReviewsUseCase;

  ReviewsBloc({required this.getReviewsUseCase})
      : super(const ReviewsState()) {
    on<ReviewsStarted>(_onStarted);
    on<ReviewsFilterChanged>(_onFilterChanged);
  }

  static const _filterKeys = ['all', 'mine', 'recent'];

  
  Future<void> _onStarted(
      ReviewsStarted event, Emitter<ReviewsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getReviewsUseCase();
      emit(state.copyWith(
          summary: result.summary,
          reviews: result.reviews,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  
  Future<void> _onFilterChanged(
      ReviewsFilterChanged event, Emitter<ReviewsState> emit) async {
    emit(state.copyWith(
        selectedFilterIndex: event.filterIndex, isLoading: true));
    try {
      final result = await getReviewsUseCase(
          filter: _filterKeys[event.filterIndex]);
      emit(state.copyWith(
          reviews: result.reviews, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
