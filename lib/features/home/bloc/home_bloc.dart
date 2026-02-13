import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/app_assets.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    /// ✅ ربط الأحداث مع الدوال
    on<HomeStarted>(_onStarted);
    on<HomeBottomTabChanged>(_onBottomTabChanged);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeFeaturedPageChanged>(_onFeaturedPageChanged);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeNotificationPressed>(_onNotificationPressed);
  }

  /// ✅ تحميل بيانات الصفحة (هلا Dummy، لاحقاً API)
  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    // =========================
    // ✅ Dummy For You (سلايدر)
    // =========================
    final featured = List.generate(6, (i) {
      return FeaturedSpace(
        id: 'space_$i',
        title: i.isEven ? 'Downtown Hub' : 'City Loft',
        rating: 4.8,
        locationText: 'City Center',
        tags: const ['Quiet', 'Fast Wi-Fi'],
        imageAsset: AppAssets.home,
      );
    });

    // =========================
    // ✅ Dummy Insights (Grid)
    // =========================
    final insights = <InsightItem>[
      const InsightItem(
        id: 'ins_1',
        title: 'Weekly plan',
        subtitle: 'Quiet spaces for\nevening work',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_2',
        title: 'Internet is',
        subtitle: 'Quiet is average',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_3',
        title: 'Offers',
        subtitle: 'Perfect for your budget',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_4',
        title: 'Best for You',
        subtitle: 'Menu Suggested\nspaces based on your\nneeds',
        imageAsset: AppAssets.home,
      ),
      // زِد كمان لو بدك (بيصيروا صفوف تحت)
    ];

    emit(state.copyWith(
      featuredSpaces: featured,
      insights: insights,
      featuredIndex: 0,
    ));

    // =========================
    // ✅ API READY (كومنت)
    // =========================
    // try {
    //   final homeData = await _repo.fetchHomeData(
    //     category: state.selectedCategoryLabel,
    //     query: state.searchText,
    //   );
    //   emit(state.copyWith(
    //     featuredSpaces: homeData.featuredSpaces,
    //     insights: homeData.insights,
    //     featuredIndex: 0,
    //   ));
    // } catch (e) {
    //   // TODO: error handling
    // }
  }

  /// ✅ تغيير التبويب السفلي
  void _onBottomTabChanged(HomeBottomTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomTabIndex: event.index));
  }

  /// ✅ اختيار Chip من الثلاثة (Nearly / New Suggestion / Private Office)
  void _onCategorySelected(HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategoryIndex: event.index, featuredIndex: 0));

    // ✅ API READY (كومنت)
    // final category = state.selectedCategoryLabel;
    // final spaces = await _repo.fetchFeaturedSpaces(category: category);
    // final insights = await _repo.fetchInsights(category: category);
    // emit(state.copyWith(featuredSpaces: spaces, insights: insights, featuredIndex: 0));
  }

  /// ✅ تحديث مؤشر صفحة السلايدر
  void _onFeaturedPageChanged(HomeFeaturedPageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(featuredIndex: event.index));
  }

  /// ✅ تحديث نص البحث
  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchText: event.text));

    // ✅ API READY (كومنت)
    // final spaces = await _repo.searchFeaturedSpaces(query: event.text);
    // emit(state.copyWith(featuredSpaces: spaces, featuredIndex: 0));
  }

  /// ✅ كبسة جرس الإشعارات (هنا dummy: نزيد نقطة)
  void _onNotificationPressed(HomeNotificationPressed event, Emitter<HomeState> emit) {
    emit(state.copyWith(unreadNotifications: state.unreadNotifications + 1));

    // ✅ API READY (كومنت)
    // await _repo.markNotificationsAsSeen();
  }
}
