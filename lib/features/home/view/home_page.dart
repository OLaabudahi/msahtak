import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masahtak_app/features/ai_concierge/view/ai_concierge_page.dart';
import 'package:masahtak_app/features/home/data/repos/home_repo_firebase.dart';
import 'package:masahtak_app/features/map/view/map_page.dart';

import '../../../constants/app_spacing.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

import '../../best_for_you/view/best_for_you_page.dart';
import '../../notifications/view/notifications_list_page.dart';
import '../../offers/view/offers_page.dart';
import '../../search_results/view/search_results_page.dart';
import '../../space_details/view/space_details_page.dart';
import '../../weekly_plan/view/weekly_plan_page.dart';
import '../../bookings/view/bookings_tab_page.dart';
import '../../bookings/view/active_bookings_page.dart';
import '../../profile/view/profile_tab_page.dart';
import '../../settings/view/settings_tab_page.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../domain/entities/insight_item.dart';
import '../widgets/category_chip.dart';
import '../widgets/featured_space_card.dart';
import '../widgets/insight_tile.dart';
import '../widgets/custom_search_bar.dart';
import 'screens/insight_details_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => HomeBloc(repo: HomeRepoFirebase())..add(const HomeStarted()),
      child: const HomePage(),
    );
  }

  Widget _buildBodyForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const _HomeTab();
      case 1:
        return BookingsTabPage.withBloc();
      case 2:
        return ProfileTabPage.withBloc();
      case 3:
        return SettingsTabPage.withBloc();
      default:
        return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(child: _buildBodyForTab(state.bottomTabIndex)),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.bottomTabIndex,
            onDestinationSelected: (i) =>
                context.read<HomeBloc>().add(HomeBottomTabChanged(i)),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                label: context.t('navHome'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                label: context.t('navBookings'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                label: context.t('navProfile'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                label: context.t('navSettings'),
              ),
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

class MySearchBar extends StatefulWidget {
  const MySearchBar({
    super.key,
    required this.hintText,
    required this.aiButtonLabel,
  });

  final String hintText;
  final String aiButtonLabel;

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAiConcierge() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AiConciergePage.withBloc()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchBar(
      controller: _searchController,
      onAiTap: _openAiConcierge,
      hintText: widget.hintText,
      aiButtonLabel: widget.aiButtonLabel,
      onSearchChanged: (q) {
        context.read<HomeBloc>().add(HomeSearchChanged(q));
      },
      onSearchSubmitted: (q) {
        context.read<HomeBloc>().add(HomeSearchChanged(q));
        if (q.trim().isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SearchResultsPage.withBloc(
                originKey: q,
                originTitle: q,
              ),
            ),
          );
        }
      },
      onSearchTap: () {},
    );
  }
}

class _HomeTabState extends State<_HomeTab> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  Timer? _resumeTimer;

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

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  void _scheduleResumeAutoSlide() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _startAutoSlide();
    });
  }

  void _cancelTimers() {
    _stopAutoSlide();
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _cancelTimers();
    _pageController.dispose();
    super.dispose();
  }

  void _openSpaceDetails(BuildContext context, String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpaceDetailsPage.withBloc(spaceId: spaceId),
      ),
    );
  }

  void _openInsightDetails(BuildContext context, InsightItem item) {
    // Meeting-ready: يفتح صفحة الحجوزات الفعّالة فقط
    if (item.id == 'ins_4') {
      Navigator.of(context).push(ActiveBookingsPage.route());
      return;
    }

    Widget page;
    switch (item.id) {
      case 'ins_best_for_you':
        page = BestForYouPage.withBloc();
        break;
      case 'ins_offers':
        page = OffersPage.withBloc();
        break;
      case 'ins_weekly_plan':
        page = WeeklyPlanPage.withBloc();
        break;
      case 'ins_spacial_Search':
        page = SearchResultsPage.withBloc(
          originKey: item.title,
          originTitle: item.title,
        );
        break;
      default:
        page = InsightDetailsPage(item: item);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();

        final categories = [context.t('catNearly'), context.t('catNewSuggestion'), context.t('catPrivateOffice')];

        final featuredCount = state.featuredSpaces.length;
        final insightsCount = state.insights.length;

        return SingleChildScrollView(
          padding: AppSpacing.screen.copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(context.t('homeTitle'), style: AppTextStyles.sectionBarTitle),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      bloc.add(const HomeNotificationPressed());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NotificationsListPage.withBloc(),
                        ),
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: 26,
                          ),
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

              MySearchBar(
                hintText: context.t('searchHint'),
                aiButtonLabel: context.t('aiConcierge'),
              ),
              AppSpacing.vMd,

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (i) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: i == categories.length - 1 ? 0 : 10,
                      ),
                      child: CategoryChip(
                        text: categories[i],
                        selected: state.selectedCategoryIndex == i,
                        onTap: () {
                          bloc.add(HomeCategorySelected(i));
                          if (i == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MapPage.withBloc(),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SearchResultsPage.withBloc(
                                  originKey: categories[i],
                                  originTitle: categories[i],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),

              AppSpacing.vLg,

              Text(context.t('forYou'), style: AppTextStyles.sectionTitle),
              AppSpacing.vMd,

              SizedBox(
                height: 260,
                child: featuredCount == 0
                    ? Center(child: Text(context.t('noSpacesYet')))
                    : Listener(
                  onPointerDown: (_) {
                    _resumeTimer?.cancel();
                    _stopAutoSlide();
                  },
                  onPointerUp: (_) {
                    _scheduleResumeAutoSlide();
                  },
                  onPointerCancel: (_) {
                    _scheduleResumeAutoSlide();
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: featuredCount,
                    onPageChanged: (i) =>
                        bloc.add(HomeFeaturedPageChanged(i)),
                    itemBuilder: (context, index) {
                      final space = state.featuredSpaces[index];

                      return FeaturedSpaceCard(
                        imageAsset: space.imageAsset,
                        imageUrl: space.imageUrl,
                        title: space.name,
                        ratingText: space.ratingText,
                        subtitle: space.subtitleLine,
                        onViewTap: () =>
                            _openSpaceDetails(context, space.id),
                      );
                    },
                  ),
                ),
              ),

              AppSpacing.vSm,

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
                          color: active
                              ? AppColors.dotInactive
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                ),

              AppSpacing.vLg,

              Text(context.t('insightsSection'), style: AppTextStyles.sectionTitle),
              AppSpacing.vMd,

              if (insightsCount == 0)
                Center(child: Text(context.t('noInsightsYet')))
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
                    // Builder ضروري عشان context.t() يستخدم context.select
                    // وهو ممنوع مباشرة داخل Sliver itemBuilder
                    return Builder(
                      builder: (ctx) => InsightTile(
                        imageAsset: item.imageAsset ?? 'assets/images/home.jpg',
                        title: item.titleKey != null
                            ? ctx.t(item.titleKey!)
                            : item.title,
                        subtitle: item.subtitleKey != null
                            ? ctx.t(item.subtitleKey!)
                            : item.subtitle,
                        onTap: () => _openInsightDetails(context, item),
                      ),
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