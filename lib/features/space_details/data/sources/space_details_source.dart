import '../models/space_details_model.dart';

abstract class SpaceDetailsSource {
  Future<SpaceDetails> fetchSpaceDetails(String spaceId);

  Future<void> addFavorite({
    required String spaceId,
    required SpaceDetails details,
  });

  Future<void> removeFavorite(String spaceId);

  Future<List<String>> getFavorites();
}
