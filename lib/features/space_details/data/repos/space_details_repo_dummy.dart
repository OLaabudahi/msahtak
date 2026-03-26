import '../../../../constants/app_assets.dart';
import '../../../booking_request/domain/entities/booking_request_entity.dart';
import '../models/space_details_model.dart';
import '../../domain/repos/space_details_repo.dart';

class SpaceDetailsRepoDummy implements SpaceDetailsRepo {
  /// ✅ دالة: داتا وهمية جاهزة للتشغيل
  @override
  Future<SpaceDetails> fetchSpaceDetails(String spaceId) async {
    await Future.delayed(const Duration(milliseconds: 450));

    return SpaceDetails(
      id: spaceId,
      name: 'Downtown Hub',
      imageAssets: const [AppAssets.home, AppAssets.home, AppAssets.home],
      subtitleLine: 'City Center • Quiet • Fast Wi-Fi',
      rating: 4.8,
      reviewsCount: 64,
      workingHours: 'Sun - Thu, 8:00 AM - 10:00 PM',
      locationAddress: '12 King St, Downtown',
      pricePerDay: 35,
      currency: '₪',

      // ✅ الرسالة الديناميكية: ممكن تكون null
      alert: const SpaceAlert(
        code: 'limited_availability',
        title: 'Limited availability',
        message:
            'This space may be unavailable today. Please check another date.',
        colorHex: '#FDE8E8',
        borderHex: '#FCA5A5',
        textHex: '#B91C1C',
      ),

      features: const [
        'Offline Meeting Room',
        'Online Meeting Room',
        'Presentation screen',
      ],
      usageStats: const [
        UsageStat(label: 'Freelancers', percent: 75),
        UsageStat(label: 'Students', percent: 15),
        UsageStat(label: 'Small teams', percent: 10),
      ],
      whyPeopleComeChips: const [
        'Focused work',
        'Online meetings',
        'Studying',
        'Team discussions',
        'Client calls',
      ],
      reviewSummary: const ReviewSummary(
        header: 'Review Summary',
        meta: 'Based on 58 reviews • last 90 days • similar users',
        topPositives: [
          'Quietness is good for studying',
          'Wi-Fi is excellent and stable',
          'Power outlets are easy to find',
        ],
        repeatedNegatives: [
          'Gets busy after 7 PM',
          'Some seats are close together',
          'Limited parking nearby',
        ],
        crowdLevel: 'Moderate',
        noise: 'Mostly quiet, busy evenings',
      ),
      latestReviews: const [
        SpaceReview(
          id: 'r1',
          userName: 'Sarah M.',
          timeAgo: '2 days ago',
          stars: 5,
          comment:
              'Quiet place and very fast internet.\nPerfect for focused work.',
        ),
        SpaceReview(
          id: 'r2',
          userName: 'Ahmad K.',
          timeAgo: '1 week ago',
          stars: 5,
          comment: 'Great for meetings in the evening.',
        ),
      ],
      offers: const [
        SpaceOffer(
          id: 'o1',
          badgeText: 'LIMITED',
          badgeType: 'limited',
          title: 'Morning Focus Deal',
          priceLine: 'Price:',
          oldPriceText: '₪35/day',
          newPriceText: '₪25/day',
          includesText: 'Includes: 8 AM - 12 PM access',
          validUntilText: 'Valid until: Sep 30',
        ),
        SpaceOffer(
          id: 'o2',
          badgeText: 'BONUS',
          badgeType: 'bonus',
          title: 'Free Meeting Room Hour',
          priceLine: 'Offer:',
          oldPriceText: null,
          newPriceText: '+ 1 hour free',
          includesText: 'Condition: With day booking',
          validUntilText: 'Valid until: Oct 10',
        ),
      ],
      policies: const SpacePolicies(
        title: 'Downtown Hub Policies',
        subtitle: 'Please read before booking. Policies may vary.',
        sections: [
          PolicySection(
            title: 'Noise & Calls',
            bullets: [
              'Quiet zones are available.',
              'Calls are allowed in designated areas only.',
              'For online meetings, please use headphones.',
              'Keep your voice low in shared areas.',
            ],
          ),
          PolicySection(
            title: 'Food & Drinks',
            bullets: [
              'Drinks are allowed at desks.',
              'Food is allowed in the dining area only.',
              'Please clean your table after eating.',
              'Strong-smell food is not recommended.',
            ],
          ),
          PolicySection(
            title: 'Conduct',
            bullets: [
              'Respect other guests and staff.',
              'Keep your workspace clean after use.',
              'Do not move furniture without permission.',
              'The space may refuse service for disruptive behavior.',
            ],
          ),
          PolicySection(
            title: 'Equipment & Space Use',
            bullets: ['Use equipment responsibly.'],
          ),
        ],
      ),

    );

    // ✅ API READY (كومنت)
    // final res = await dio.get('/spaces/$spaceId/details');
    // return SpaceDetails.fromJson(res.data);
  }
  SpaceSummaryEntity mapToBookingSummary(SpaceDetails space) {
    return SpaceSummaryEntity(
      id: space.id,
      name: space.name,
      basePricePerDay: space.pricePerDay,
      currency: space.currency,
    );
  }

}
