import '../repos/space_details_repo.dart';

class GetFavoritesUseCase {
  final SpaceDetailsRepo repo;
  const GetFavoritesUseCase(this.repo);

  Future<List<String>> call() {
    return repo.getFavorites();
  }
}
