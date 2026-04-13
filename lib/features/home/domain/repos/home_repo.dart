import '../entities/home_featured_space_entity.dart';

abstract class HomeRepo {
  Future<List<HomeFeaturedSpaceEntity>> getHomeData();

  Future<List<HomeFeaturedSpaceEntity>> getRecommendedSpaces();

  Future<List<HomeFeaturedSpaceEntity>> getNearbySpaces();

  Future<List<HomeFeaturedSpaceEntity>> getFeaturedSpaces();
}
