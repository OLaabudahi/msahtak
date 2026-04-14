import '../../../space_details/domain/usecases/get_favorites_usecase.dart';
import '../../../search_results/domain/entities/space_entity.dart';
import '../repos/saved_spaces_repo.dart';

class GetSavedSpacesUseCase {
  final SavedSpacesRepo repo;
  final GetFavoritesUseCase getFavoritesUseCase;

  GetSavedSpacesUseCase({
    required this.repo,
    required this.getFavoritesUseCase,
  });

  Future<List<SpaceEntity>> call() async {
    final favoriteIds = await getFavoritesUseCase.call();
    return repo.getSavedSpaces(favoriteIds);
  }
}
