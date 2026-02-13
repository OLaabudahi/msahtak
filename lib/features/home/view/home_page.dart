import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_spacing.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../bloc/home_bloc.dart';
import '../widgets/category_chip.dart';
import '../widgets/featured_space_card.dart';
import '../widgets/insight_tile.dart';
import 'screens/booking_tab_page.dart';
import 'screens/profile_tab_page.dart';
import 'screens/settings_tab_page.dart';
import 'screens/space_details_page.dart';
import 'screens/insight_details_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// ✅ هذه الدالة عشان تفتح الصفحة ومعها HomeBloc جاهز
  static Widget withBloc() {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeStarted()),
      child: const HomePage(),
    );
  }

  /// ✅ هذه الدالة بتجيب الجسم حسب التبويب السفلي
  Widget _buildBodyForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const _HomeTab();
      case 1:
        return const BookingTabPage();
      case 2:
        return const ProfileTabPage();
      case 3:
        return const SettingsTabPage();
      default:
        return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      /// ✅ بناء الصفحة مع Bottom Navigation
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(child: _buildBodyForTab(state.bottomTabIndex)),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.bottomTabIndex,
            onDestinationSelected: (i) => context.read<HomeBloc>().add(HomeBottomTabChanged(i)),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Bookings'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  Timer? _resumeTimer;

  /// ✅ تشغيل التحريك التلقائي حسب عدد الكروت الموجود حالياً
  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      if (!_pageController.hasClients) return;

      final state = context.read<HomeBloc>().state;
      final count = state.featuredSpaces.length;
      if (count <= 1) return;

      final next = (state.featuredIndex + 1) % count;

      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
      );
    });
  }

  /// ✅ إيقاف التحريك التلقائي فوراً
  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  /// ✅ إعادة التحريك بعد ثانيتين من ترك المستخدم للسلايدر
  void _scheduleResumeAutoSlide() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _startAutoSlide();
    });
  }

  /// ✅ تنظيف كل التايمرز
  void _cancelTimers() {
    _stopAutoSlide();
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }

  /// ✅ تهيئة الكنترولر وتشغيل التحريك
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoSlide();
  }

  /// ✅ تنظيف الموارد
  @override
  void dispose() {
    _cancelTimers();
    _pageController.dispose();
    super.dispose();
  }

  /// ✅ فتح صفحة تفاصيل المساحة (كارد For You)
  void _openSpaceDetails(BuildContext context, String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SpaceDetailsPage(spaceId: spaceId)),
    );
  }

  /// ✅ فتح صفحة تفاصيل Insight (كل كارد له صفحة)
  void _openInsightDetails(BuildContext context, InsightItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => InsightDetailsPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      /// ✅ بناء تبويب Home بالكامل مثل التصميم
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();

        const categories = ['Nearly', 'New Suggestion', 'Private Office'];

        final featuredCount = state.featuredSpaces.length;
        final insightsCount = state.insights.length;

        return SingleChildScrollView(
          padding: AppSpacing.screen.copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========= Top Bar (Home + Bell) =========
              Row(
                children: [
                  const Text('Home', style: AppTextStyles.sectionTitle),
                  const Spacer(),
                  InkWell(
                    onTap: () => bloc.add(const HomeNotificationPressed()),
                    customBorder: const CircleBorder(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.notifications_none_rounded, size: 26),
                        ),
                        if (state.unreadNotifications > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              AppSpacing.vMd,

              // ========= Search + AI Concierge =========
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search, color: AppColors.hint),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => bloc.add(HomeSearchChanged(v)),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.hMd,
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2B6CB0)],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'AI Concierge',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.vMd,

              // ========= Chips Row =========
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (i) {
                    return Padding(
                      padding: EdgeInsets.only(right: i == categories.length - 1 ? 0 : 10),
                      child: CategoryChip(
                        text: categories[i],
                        selected: state.selectedCategoryIndex == i,
                        onTap: () => bloc.add(HomeCategorySelected(i)),
                      ),
                    );
                  }),
                ),
              ),

              AppSpacing.vLg,

              // ========= For You =========
              const Text('For You', style: AppTextStyles.sectionTitle),
              AppSpacing.vMd,

              SizedBox(
                height: 260,
                child: featuredCount == 0
                    ? const Center(child: Text('No spaces yet'))
                    : Listener(
                  onPointerDown: (_) {
                    // أول ما يلمس المستخدم -> وقف التحريك
                    _resumeTimer?.cancel();
                    _stopAutoSlide();
                  },
                  onPointerUp: (_) {
                    // لما يترك -> رجع التحريك بعد ثانيتين
                    _scheduleResumeAutoSlide();
                  },
                  onPointerCancel: (_) {
                    _scheduleResumeAutoSlide();
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: featuredCount,
                    onPageChanged: (i) => bloc.add(HomeFeaturedPageChanged(i)),
                    itemBuilder: (context, index) {
                      final space = state.featuredSpaces[index];
                      return FeaturedSpaceCard(
                        // ✅ هلا asset، لاحقاً API:
                        // imageUrl: space.imageUrl,
                        imageAsset: space.imageAsset ?? AppAssets.home,
                        title: space.title,
                        ratingText: space.rating.toStringAsFixed(1),
                        subtitle: '${space.locationText} • ${space.tags.join(" • ")}',
                        onViewTap: () => _openSpaceDetails(context, space.id),
                      );
                    },
                  ),
                ),
              ),

              AppSpacing.vSm,

              // ========= Dots =========
              if (featuredCount > 1)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(featuredCount, (i) {
                      final active = i == state.featuredIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? AppColors.dotInactive : AppColors.border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                ),

              AppSpacing.vLg,

              // ========= Insights =========
              const Text('Insights', style: AppTextStyles.sectionTitle),
              AppSpacing.vMd,

              if (insightsCount == 0)
                const Center(child: Text('No insights yet'))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: insightsCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.18,
                  ),
                  itemBuilder: (context, index) {
                    final item = state.insights[index];
                    return InsightTile(
                      // ✅ هلا asset، لاحقاً API:
                      // imageUrl: item.imageUrl,
                      imageAsset: item.imageAsset ?? AppAssets.home,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: () => _openInsightDetails(context, item),
                    );
                  },
                ),

              AppSpacing.vLg,
            ],
          ),
        );
      },
    );
  }
}
