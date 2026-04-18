import '../entities/insight_item.dart';
import '../entities/home_featured_space_entity.dart';

abstract class HomeRepo {
  Future<List<HomeFeaturedSpaceEntity>> getHomeData();

  Future<List<HomeFeaturedSpaceEntity>> getRecommendedSpaces();

  Future<List<HomeFeaturedSpaceEntity>> getNearbySpaces();

  Future<List<HomeFeaturedSpaceEntity>> getFeaturedSpaces();

  Future<List<InsightItem>> getInsights({required String langCode});
}
