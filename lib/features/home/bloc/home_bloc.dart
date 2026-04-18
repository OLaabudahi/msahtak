import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/local_storage_service.dart';
import '../../notifications/domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/get_featured_spaces_usecase.dart';
import '../domain/usecases/get_home_data_usecase.dart';
import '../domain/usecases/get_insights_usecase.dart';
import '../domain/usecases/get_nearby_spaces_usecase.dart';
import '../domain/usecases/get_recommended_spaces_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;
  final GetRecommendedSpacesUseCase getRecommendedSpacesUseCase;
  final GetNearbySpacesUseCase getNearbySpacesUseCase;
  final GetFeaturedSpacesUseCase getFeaturedSpacesUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetInsightsUseCase getInsightsUseCase;
  final LocalStorageService _storage = LocalStorageService();

  HomeBloc({
    required this.getHomeDataUseCase,
    required this.getRecommendedSpacesUseCase,
    required this.getNearbySpacesUseCase,
    required this.getFeaturedSpacesUseCase,
    required this.getNotificationsUseCase,
    required this.getInsightsUseCase,
  }) : super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeBottomTabChanged>(_onBottomTabChanged);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeNotificationPressed>(_onNotificationPressed);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeFeaturedPageChanged>(_onFeaturedPageChanged);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final featured = await getHomeDataUseCase();
      await getRecommendedSpacesUseCase();
      await getNearbySpacesUseCase();
      await getFeaturedSpacesUseCase();
      final notifications = await getNotificationsUseCase();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      final langCode = await _storage.getLocaleCode() ?? 'en';
      final insights = await getInsightsUseCase(langCode: langCode);

      emit(state.copyWith(
        isLoading: false,
        featuredSpaces: featured,
        featuredIndex: 0,
        insights: insights,
        unreadNotifications: unreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onBottomTabChanged(HomeBottomTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomTabIndex: event.index));
  }

  void _onCategorySelected(HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }

  void _onNotificationPressed(HomeNotificationPressed event, Emitter<HomeState> emit) {
    emit(state.copyWith(unreadNotifications: 0));
  }

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {}

  void _onFeaturedPageChanged(HomeFeaturedPageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(featuredIndex: event.index));
  }
}
