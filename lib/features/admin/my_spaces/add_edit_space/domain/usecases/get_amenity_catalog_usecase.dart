import '../entities/amenity_entity.dart';
import '../repos/add_edit_space_repo.dart';

class GetAmenityCatalogUseCase {
  final AddEditSpaceRepo repo;
  const GetAmenityCatalogUseCase(this.repo);

  Future<List<AmenityEntity>> call() => repo.getAmenityCatalog();
}
