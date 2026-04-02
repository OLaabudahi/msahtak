import '../entities/amenity_entity.dart';
import '../entities/space_form_entity.dart';

abstract class AddEditSpaceRepo {
  Future<SpaceFormEntity> getSpaceForm({required String? spaceId});
  Future<void> saveSpace({required SpaceFormEntity form});

  
  Future<List<AmenityEntity>> getAmenityCatalog();
  Future<AmenityEntity> addAmenity({required String name});
}


