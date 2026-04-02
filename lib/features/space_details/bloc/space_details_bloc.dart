import 'package:bloc/bloc.dart';
import '../domain/repos/space_details_repo.dart';
import 'space_details_event.dart';
import 'space_details_state.dart';

class SpaceDetailsBloc extends Bloc<SpaceDetailsEvent, SpaceDetailsState> {
  final SpaceDetailsRepo repo;

  SpaceDetailsBloc({required this.repo}) : super(SpaceDetailsState.initial()) {
    on<SpaceDetailsStarted>(_onStarted);
    on<SpaceDetailsTabChanged>(_onTabChanged);
    on<SpaceDetailsCarouselChanged>(_onCarouselChanged);
  }

  /// âœ… ط¯ط§ظ„ط©: طھط­ظ…ظٹظ„ طھظپط§طµظٹظ„ ط§ظ„ظ…ط³ط§ط­ط© (Dummy ط§ظ„ط¢ظ†)
  Future<void> _onStarted(
    SpaceDetailsStarted event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final details = await repo.fetchSpaceDetails(event.spaceId);
      emit(state.copyWith(loading: false, details: details, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, details: null, error: e.toString()));
    }
  }

  /// âœ… ط¯ط§ظ„ط©: طھط؛ظٹظٹط± ط§ظ„طھط§ط¨
  void _onTabChanged(
    SpaceDetailsTabChanged event,
    Emitter<SpaceDetailsState> emit,
  ) {
    emit(state.copyWith(tabIndex: event.index));
  }

  /// âœ… ط¯ط§ظ„ط©: طھط؛ظٹظٹط± ظ…ط¤ط´ط± طµظˆط± ط§ظ„ظƒط§ط±ظˆط³ظٹظ„
  void _onCarouselChanged(
    SpaceDetailsCarouselChanged event,
    Emitter<SpaceDetailsState> emit,
  ) {
    emit(state.copyWith(carouselIndex: event.index));
  }
}


