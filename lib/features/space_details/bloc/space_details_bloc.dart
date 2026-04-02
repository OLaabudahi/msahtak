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

  /// ✅ دالة: تحميل تفاصيل المساحة (Dummy الآن)
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

  /// ✅ دالة: تغيير التاب
  void _onTabChanged(
    SpaceDetailsTabChanged event,
    Emitter<SpaceDetailsState> emit,
  ) {
    emit(state.copyWith(tabIndex: event.index));
  }

  /// ✅ دالة: تغيير مؤشر صور الكاروسيل
  void _onCarouselChanged(
    SpaceDetailsCarouselChanged event,
    Emitter<SpaceDetailsState> emit,
  ) {
    emit(state.copyWith(carouselIndex: event.index));
  }
}
