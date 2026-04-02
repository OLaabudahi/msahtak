import '../entities/home_featured_space_entity.dart';

abstract class HomeRepo {
  Future<List<HomeFeaturedSpaceEntity>> fetchForYou();
}


