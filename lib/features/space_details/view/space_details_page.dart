import 'dart:async';

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_spacing.dart';
import '../../booking_request/domain/entities/booking_request_entity.dart';
import '../../booking_request/view/booking_request_routes.dart';
import '../../../../core/di/app_injector.dart';
import '../bloc/space_details_bloc.dart';
import '../bloc/space_details_event.dart';
import '../bloc/space_details_state.dart';
import '../data/repos/space_details_repo_firebase.dart';
import '../widgets/alert_banner.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/offer_card.dart';
import '../widgets/reason_chip.dart';
import '../widgets/review_card.dart';
import '../widgets/segmented_tabs.dart';
import '../widgets/usage_bars.dart';
import 'package:Msahtak/features/admin/my_spaces/add_edit_space/view/location_picker_page.dart';
import 'sheets/policies_sheet.dart';
import 'sheets/review_summary_sheet.dart';

class SpaceDetailsPage extends StatefulWidget {
  final String spaceId;

  const SpaceDetailsPage({super.key, required this.spaceId});

  /// ✅ دالة: فتح الصفحة مع Bloc + Repo (Dummy حالياً)
  static Widget withBloc({required String spaceId}) {
    return BlocProvider(
      create: (_) =>
          SpaceDetailsBloc(repo: SpaceDetailsRepoFirebase())
            ..add(SpaceDetailsStarted(spaceId)),
      child: SpaceDetailsPage(spaceId: spaceId),
    );
  }

  /*static Widget withBloc({required String spaceId}) {
    return BlocProvider(
      create: (_) => SpaceDetailsBloc(
        repo: SpaceDetailsRepoFirebase(
          source: SpaceDetailsFirebaseSource(FirestoreApi()),
        ),
      )..add(SpaceDetailsStarted(spaceId)),
      child: SpaceDetailsPage(spaceId: spaceId),
    );
  }
*/
  @override
  State<SpaceDetailsPage> createState() => _SpaceDetailsPageState();
}

class _SpaceDetailsPageState extends State<SpaceDetailsPage> {
  // ====== Tabs Swipe Controller ======
  late final PageController _tabsController;

  // ====== Images Auto Carousel ======
  late final PageController _imagesController;
  Timer? _imageAutoTimer;
  Timer? _imageResumeTimer;

  @override
  void initState() {
    super.initState();
    _tabsController = PageController();
    _imagesController = PageController();

    // ✅ شغّل تحريك الصور تلقائياً كل 3 ثواني
    _startImageAutoSlide();
  }

  @override
  void dispose() {
    _imageAutoTimer?.cancel();
    _imageResumeTimer?.cancel();
    _tabsController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  /// ✅ دالة: تشغيل تحريك الصور تلقائياً (كل 3 ثواني)
  void _startImageAutoSlide() {
    _imageAutoTimer?.cancel();
    _imageAutoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      if (!_imagesController.hasClients) return;

      final state = context.read<SpaceDetailsBloc>().state;
      final d = state.details;
      if (d == null) return;

      final count = d.imageAssets.length;
      if (count <= 1) return;

      final next = (state.carouselIndex + 1) % count;

      _imagesController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
      );
    });
  }

  /// ✅ دالة: إيقاف تحريك الصور فوراً
  void _stopImageAutoSlide() {
    _imageAutoTimer?.cancel();
    _imageAutoTimer = null;
  }

  /// ✅ دالة: إعادة تحريك الصور بعد ثانيتين من ترك المستخدم
  void _scheduleResumeImageAutoSlide() {
    _imageResumeTimer?.cancel();
    _imageResumeTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _startImageAutoSlide();
    });
  }

  /// ✅ دالة: فتح Dialog سياسات المكان
  void _openPoliciesSheet(BuildContext context, SpaceDetailsState state) {
    final policies = state.details!.policies;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: PoliciesSheet(policies: policies),
      ),
    );
  }

  /// ✅ دالة: فتح Dialog Review Summary
  void _openReviewSummarySheet(BuildContext context, SpaceDetailsState state) {
    final summary = state.details!.reviewSummary;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ReviewSummarySheet(summary: summary),
      ),
    );
  }

  /// ✅ دالة: لما نكبس على Tab من segmented، نعمل animate للـ PageView
  void _animateToTab(int index) {
    if (!_tabsController.hasClients) return;
    _tabsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpaceDetailsBloc, SpaceDetailsState>(
      listenWhen: (p, c) => p.tabIndex != c.tabIndex,
      listener: (context, state) {
        // ✅ لما الـ bloc يغير tabIndex (من tap أو swipe) خلّي الـ PageView يروح لنفس المكان
        _animateToTab(state.tabIndex);
      },
      child: BlocBuilder<SpaceDetailsBloc, SpaceDetailsState>(
        /// ✅ دالة: بناء الشاشة كاملة حسب state
        builder: (context, state) {
          if (state.loading) {
            return const Scaffold(
              body: SafeArea(child: Center(child: CircularProgressIndicator())),
            );
          }

          if (state.error != null || state.details == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Space Details')),
              body: SafeArea(
                child: Padding(
                  padding: AppSpacing.screen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('صار خطأ: ${state.error ?? "Unknown"}'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.read<SpaceDetailsBloc>().add(
                          SpaceDetailsStarted(widget.spaceId),
                        ),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final d = state.details!;
          final bloc = context.read<SpaceDetailsBloc>();

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // =========================
                  // ✅ Header ثابت
                  // =========================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(999),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            d.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // ✅ صور (تتحرك تلقائياً + توقف باللمس)
                  // =========================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Listener(
                          onPointerDown: (_) {
                            _imageResumeTimer?.cancel();
                            _stopImageAutoSlide();
                          },
                          onPointerUp: (_) => _scheduleResumeImageAutoSlide(),
                          onPointerCancel: (_) =>
                              _scheduleResumeImageAutoSlide(),
                          child: PageView.builder(
                            controller: _imagesController,
                            itemCount: d.imageAssets.length,
                            onPageChanged: (i) =>
                                bloc.add(SpaceDetailsCarouselChanged(i)),
                            itemBuilder: (_, i) {
                              final src = d.imageAssets[i];
                              if (src.startsWith('http')) {
                                return Image.network(
                                  src,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ColoredBox(color: Color(0xFFEEEEEE)),
                                );
                              }
                              return Image.asset(src, fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  DotIndicator(
                    count: d.imageAssets.length,
                    active: state.carouselIndex,
                  ),

                  // السعر + rating
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${d.pricePerDay} /day',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2F3542),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${d.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.amber,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            d.subtitleLine,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${d.reviewsCount} reviews',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // ✅ Tabs ثابتة + Swipe
                  // =========================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: SegmentedTabs(
                      index: state.tabIndex,
                      onChanged: (i) {
                        // 1) حدّث الـ bloc
                        bloc.add(SpaceDetailsTabChanged(i));
                        // 2) حرّك الـ PageView
                        _animateToTab(i);
                      },
                    ),
                  ),

                  // =========================
                  // ✅ محتوى المتغير (Swipe بين التابات)
                  // =========================
                  Expanded(
                    child: PageView(
                      controller: _tabsController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        if (index != state.tabIndex) {
                          bloc.add(SpaceDetailsTabChanged(index));
                        }
                      },
                      children: [
                        // -------- Overview --------
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (d.alert != null) ...[
                                AlertBanner(alert: d.alert!),
                                const SizedBox(height: 14),
                              ],

                              const Text(
                                'Working hours',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      d.workingHours,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _openPoliciesSheet(context, state),
                                    child: const Text(
                                      'View Space Policies',
                                      style: TextStyle(
                                        color: AppColors.link,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // ✅ placeholder: share
                                    },
                                    child: const Icon(
                                      Icons.share_outlined,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                d.locationAddress,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  if (d.lat != null && d.lng != null) {
                                    LocationPickerPage.show(
                                      context,
                                      lat: d.lat,
                                      lng: d.lng,
                                    );
                                  }
                                },
                                child: const Text(
                                  '📍 View location',
                                  style: TextStyle(
                                    color: AppColors.amber,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // ✅ Features (لوحدها)
                              const Text(
                                'Features',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 8),
                              ...d.features.map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    '• $f',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ✅ Who usually uses this space (نزلناه تحت + Gradient مثل AI)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.surface2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Who usually uses this space',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    UsageBars(
                                      items: d.usageStats
                                          .map(
                                            (e) => {
                                              'label': e.label,
                                              'percent': e.percent,
                                            },
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // -------- Reviews --------
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Why people come here',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: d.whyPeopleComeChips
                                    .map((t) => ReasonChip(text: t))
                                    .toList(),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Text(
                                    '${d.rating} ★',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Based on ${d.reviewsCount} reviews',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 42,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                          color: AppColors.amber,
                                        ),
                                        backgroundColor: const Color(
                                          0xFFFFF7ED,
                                        ),
                                      ),
                                      onPressed: () => _openReviewSummarySheet(
                                        context,
                                        state,
                                      ),
                                      child: const Text(
                                        'Review Summary',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Latest reviews',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: d.latestReviews
                                      .map(
                                        (r) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: ReviewCard(review: r),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // -------- Offers --------
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available offers',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Offers are applied during booking. You can choose or skip any offer later.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...d.offers.map(
                                (o) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: OfferCard(offer: o),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ زر ثابت تحت
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.amber,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Request Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      final summary = SpaceSummaryEntity(
                        id: d.id,
                        name: d.name,
                        basePricePerDay: d.pricePerDay,
                        currency: d.currency,
                      );
                      Navigator.of(context).push(
                        BookingRequestRoutes.requestBooking(
                          bloc: AppInjector.createBookingBloc(),
                          space: summary,
                        ),
                      );

                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
