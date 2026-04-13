import '../../data/models/space_details_model.dart';

abstract class SpaceDetailsRepo {
  Future<SpaceDetails> fetchSpaceDetails(String spaceId);

  Future<void> addToFavorites({
    required String spaceId,
    required SpaceDetails details,
  });

  Future<void> removeFromFavorites(String spaceId);

  Future<List<String>> getFavorites();
}
