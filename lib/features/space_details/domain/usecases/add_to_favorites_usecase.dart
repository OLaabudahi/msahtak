import '../../data/models/space_details_model.dart';
import '../repos/space_details_repo.dart';

class AddToFavoritesUseCase {
  final SpaceDetailsRepo repo;
  const AddToFavoritesUseCase(this.repo);

  Future<void> call({
    required String spaceId,
    required SpaceDetails details,
  }) {
    return repo.addToFavorites(spaceId: spaceId, details: details);
  }
}
