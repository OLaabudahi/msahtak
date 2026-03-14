import '../models/amenity_model.dart';
import '../models/space_form_model.dart';

abstract class AddEditSpaceSource {
  Future<SpaceFormModel> fetchSpaceForm({required String? spaceId});
  Future<void> saveSpace({required SpaceFormModel form});

  // NEW: API-ready
  Future<List<AmenityModel>> fetchAmenityCatalog();
  Future<AmenityModel> createAmenity({required String name});
}
