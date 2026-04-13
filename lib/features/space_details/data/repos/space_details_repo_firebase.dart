import '../../domain/repos/space_details_repo.dart';
import '../models/space_details_model.dart';
import '../sources/space_details_firebase_source.dart';
import '../sources/space_details_source.dart';

class SpaceDetailsRepoFirebase implements SpaceDetailsRepo {
  final SpaceDetailsSource source;

  SpaceDetailsRepoFirebase({SpaceDetailsSource? source})
      : source = source ?? SpaceDetailsFirebaseSource();

  @override
  Future<SpaceDetails> fetchSpaceDetails(String spaceId) {
    return source.fetchSpaceDetails(spaceId);
  }

  @override
  Future<void> addToFavorites({
    required String spaceId,
    required SpaceDetails details,
  }) {
    return source.addFavorite(spaceId: spaceId, details: details);
  }

  @override
  Future<void> removeFromFavorites(String spaceId) {
    return source.removeFavorite(spaceId);
  }

  @override
  Future<List<String>> getFavorites() {
    return source.getFavorites();
  }
}
