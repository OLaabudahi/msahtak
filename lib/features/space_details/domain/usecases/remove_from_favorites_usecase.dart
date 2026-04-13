import '../repos/space_details_repo.dart';

class RemoveFromFavoritesUseCase {
  final SpaceDetailsRepo repo;
  const RemoveFromFavoritesUseCase(this.repo);

  Future<void> call(String spaceId) {
    return repo.removeFromFavorites(spaceId);
  }
}
