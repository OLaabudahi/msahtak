import '../entities/amenity_entity.dart';
import '../repos/add_edit_space_repo.dart';

class AddAmenityUseCase {
  final AddEditSpaceRepo repo;
  const AddAmenityUseCase(this.repo);

  Future<AmenityEntity> call({required String name}) => repo.addAmenity(name: name);
}
