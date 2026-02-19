import 'dart:async';

import '../../domain/entities/home_featured_space_entity.dart';
import '../../domain/repos/home_repo.dart';

class HomeRepoDummy implements HomeRepo {
  @override
  Future<List<HomeFeaturedSpaceEntity>> fetchForYou() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return const [
      HomeFeaturedSpaceEntity(
        id: 'SPACE-001',
        name: 'Downtown Hub',
        imageAsset: 'assets/images/spaces/downtown_hub.jpg',
        subtitleLine: 'City Center • Quiet • Fast Wi-Fi',
        rating: 4.8,
        pricePerDay: 35,
        currency: '₪',
      ),
      HomeFeaturedSpaceEntity(
        id: 'SPACE-002',
        name: 'Blue Owl',
        imageAsset: 'assets/images/spaces/blue_owl.jpg',
        subtitleLine: 'Cozy • Good lighting • Calm',
        rating: 4.6,
        pricePerDay: 45,
        currency: '₪',
      ),
    ];

    // API-ready:
    // final res = await dio.get('/home/for-you');
    // return (res.data as List).map((e) => HomeFeaturedSpaceModel.fromJson(e)).toList();
  }
}
