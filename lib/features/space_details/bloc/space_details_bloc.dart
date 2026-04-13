import 'package:bloc/bloc.dart';
import '../domain/usecases/add_to_favorites_usecase.dart';
import '../domain/usecases/get_favorites_usecase.dart';
import '../domain/usecases/remove_from_favorites_usecase.dart';
import '../domain/repos/space_details_repo.dart';
import 'space_details_event.dart';
import 'space_details_state.dart';

class SpaceDetailsBloc extends Bloc<SpaceDetailsEvent, SpaceDetailsState> {
  final SpaceDetailsRepo repo;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  SpaceDetailsBloc({required this.repo})
      : addToFavoritesUseCase = AddToFavoritesUseCase(repo),
        removeFromFavoritesUseCase = RemoveFromFavoritesUseCase(repo),
        getFavoritesUseCase = GetFavoritesUseCase(repo),
        super(SpaceDetailsState.initial()) {
    on<SpaceDetailsStarted>(_onStarted);
    on<SpaceDetailsTabChanged>(_onTabChanged);
    on<SpaceDetailsCarouselChanged>(_onCarouselChanged);
    on<SpaceDetailsToggleFavoritePressed>(_onToggleFavoritePressed);
    on<SpaceDetailsFavoriteNoticeConsumed>(_onFavoriteNoticeConsumed);
  }

  /// ✅ دالة: تحميل تفاصيل المساحة (Dummy الآن)
  Future<void> _onStarted(
    SpaceDetailsStarted event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final details = await repo.fetchSpaceDetails(event.spaceId);
      final favorites = await getFavoritesUseCase();
      emit(state.copyWith(
        loading: false,
        details: details,
        isFavorite: favorites.contains(details.id),
        error: null,
      ));
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

  Future<void> _onToggleFavoritePressed(
    SpaceDetailsToggleFavoritePressed event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    final details = state.details;
    if (details == null || state.favoriteUpdating) return;

    emit(state.copyWith(favoriteUpdating: true));
    try {
      if (state.isFavorite) {
        await removeFromFavoritesUseCase(details.id);
        emit(state.copyWith(
          isFavorite: false,
          favoriteUpdating: false,
          favoriteNoticeKey: 'removedFromFavorites',
        ));
      } else {
        await addToFavoritesUseCase(spaceId: details.id, details: details);
        emit(state.copyWith(
          isFavorite: true,
          favoriteUpdating: false,
          favoriteNoticeKey: 'savedToFavorites',
        ));
      }
    } catch (_) {
      emit(state.copyWith(favoriteUpdating: false));
    }
  }

  void _onFavoriteNoticeConsumed(
    SpaceDetailsFavoriteNoticeConsumed event,
    Emitter<SpaceDetailsState> emit,
  ) {
    emit(state.copyWith(clearFavoriteNotice: true));
  }
}
