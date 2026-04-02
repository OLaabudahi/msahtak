import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/home_featured_space_entity.dart';
import '../domain/entities/insight_item.dart';
import '../domain/repos/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo repo;

  
  List<HomeFeaturedSpaceEntity> _allFeatured = const [];

  HomeBloc({required this.repo}) : super(HomeState.initial()) {
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
      final featured = await repo.fetchForYou();
      _allFeatured = featured;

      emit(state.copyWith(
        isLoading: false,
        featuredSpaces: featured,
        featuredIndex: 0,
        insights: _buildDummyInsights(),
        unreadNotifications: state.unreadNotifications,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onBottomTabChanged(
      HomeBottomTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomTabIndex: event.index));
  }

  void _onCategorySelected(
      HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }

  void _onNotificationPressed(
      HomeNotificationPressed event, Emitter<HomeState> emit) {
    emit(state.copyWith(unreadNotifications: 0));
  }

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    final q = event.query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(state.copyWith(featuredSpaces: _allFeatured, featuredIndex: 0));
      return;
    }

    
    final filtered = _allFeatured.where((s) {
      final hasWifi = s.tags.any((t) => t.contains('wifi'));
      final withinRange = (s.distanceKm ?? 999) <= 0.1;
      final textMatch = s.name.toLowerCase().contains(q) ||
          s.subtitleLine.toLowerCase().contains(q);
      return hasWifi && withinRange && textMatch;
    }).toList();

    
    if (filtered.isEmpty) {
      final textOnly = _allFeatured.where((s) {
        return s.name.toLowerCase().contains(q) ||
            s.subtitleLine.toLowerCase().contains(q);
      }).toList();
      emit(state.copyWith(featuredSpaces: textOnly, featuredIndex: 0));
      return;
    }

    emit(state.copyWith(featuredSpaces: filtered, featuredIndex: 0));
  }

  void _onFeaturedPageChanged(
      HomeFeaturedPageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(featuredIndex: event.index));
  }

  List<InsightItem> _buildDummyInsights() {
    return const [
      InsightItem(
        id: 'ins_best_for_you',
        titleKey: 'insBestForYou',
        subtitleKey: 'insBestForYouSub',
        title: 'Best For You',
        subtitle: 'Find the space that matches your goal.',
        imageAsset: 'assets/images/home.png',
      ),
      InsightItem(
        id: 'ins_offers',
        titleKey: 'insExclusiveDeals',
        subtitleKey: 'insExclusiveDealsSub',
        title: "Today's Offers",
        subtitle: 'Exclusive deals on top spaces.',
        imageAsset: 'assets/images/home.png',
      ),
      InsightItem(
        id: 'ins_weekly_plan',
        titleKey: 'insWeeklyPlan',
        subtitleKey: 'insWeeklyPlanSub',
        title: 'Weekly Plan',
        subtitle: 'Unlock your productivity hub.',
        imageAsset: 'assets/images/home.png',
      ),
      InsightItem(
        id: 'ins_4',
        titleKey: 'insMeetingChecklist',
        subtitleKey: 'insMeetingChecklistSub',
        title: 'Meeting-ready checklist',
        subtitle: "Don't miss essentials.",
        imageAsset: 'assets/images/home.png',
      ),
    ];
  }
}
