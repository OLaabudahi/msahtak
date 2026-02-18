import 'package:bloc/bloc.dart';
import '../../../constants/app_assets.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeBottomTabChanged>(_onTabChanged);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeFeaturedPageChanged>(_onFeaturedChanged);
    on<HomeNotificationPressed>(_onNotificationPressed);
  }

  /// ✅ تحميل Dummy data للهوم (جاهزة تتبدل بالـ API لاحقًا)
  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    // Dummy
    final featured = <FeaturedSpace>[
      const FeaturedSpace(
        id: 'space_1',
        title: 'The WorkHub Space',
        rating: 4.8,
        locationText: 'Amman',
        tags: ['Quiet', 'Fast Wi-Fi'],
        imageAsset: AppAssets.home, // بدلها بالصور تبعتك لو عندك
      ),
      const FeaturedSpace(
        id: 'space_2',
        title: 'Cozy Study Corner',
        rating: 4.6,
        locationText: 'Irbid',
        tags: ['Budget', 'Study'],
        imageAsset: AppAssets.home,
      ),
      const FeaturedSpace(
        id: 'space_3',
        title: 'Private Office Pro',
        rating: 4.9,
        locationText: 'Zarqa',
        tags: ['Office', 'Meetings'],
        imageAsset: AppAssets.home,
      ),
    ];

    final insights = <InsightItem>[
      const InsightItem(
        id: 'ins_1',
        title: 'Best for Study',
        subtitle: 'Quiet • Strong Internet',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_2',
        title: 'Weekly saves more',
        subtitle: 'Save up to 25%',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_3',
        title: 'Top rated nearby',
        subtitle: '4.8+ average',
        imageAsset: AppAssets.home,
      ),
      const InsightItem(
        id: 'ins_4',
        title: 'Private Offices',
        subtitle: 'Focus & calls',
        imageAsset: AppAssets.home,
      ),
    ];

    emit(state.copyWith(
      featuredSpaces: featured,
      insights: insights,
      featuredIndex: 0,
    ));

    // ✅ API READY (كومنت)
    // final featured = await homeRepo.fetchFeaturedSpaces();
    // final insights = await homeRepo.fetchInsights();
    // emit(state.copyWith(featuredSpaces: featured, insights: insights, featuredIndex: 0));
  }

  /// ✅ تغيير bottom tab
  void _onTabChanged(HomeBottomTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomTabIndex: event.index));
  }

  /// ✅ اختيار category
  void _onCategorySelected(HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }

  /// ✅ البحث
  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// ✅ تغيير صفحة السلايدر
  void _onFeaturedChanged(HomeFeaturedPageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(featuredIndex: event.index));
  }

  /// ✅ ضغط جرس الإشعارات (هلا dummy)
  void _onNotificationPressed(HomeNotificationPressed event, Emitter<HomeState> emit) {
    // مثال: تصفير unread
    emit(state.copyWith(unreadNotifications: 0));
  }
}
