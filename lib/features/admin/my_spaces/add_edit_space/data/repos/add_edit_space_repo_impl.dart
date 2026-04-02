import '../../domain/entities/amenity_entity.dart';
import '../../domain/entities/space_form_entity.dart';
import '../../domain/repos/add_edit_space_repo.dart';
import '../models/space_form_model.dart';
import '../sources/add_edit_space_source.dart';

class AddEditSpaceRepoImpl implements AddEditSpaceRepo {
  final AddEditSpaceSource source;
  const AddEditSpaceRepoImpl(this.source);

  @override
  Future<SpaceFormEntity> getSpaceForm({required String? spaceId}) async {
    final m = await source.fetchSpaceForm(spaceId: spaceId);
    return m.toEntity();
  }

  @override
  Future<void> saveSpace({required SpaceFormEntity form}) {
    final model = SpaceFormModel.fromEntity(form);
    return source.saveSpace(form: model);
  }

  @override
  Future<List<AmenityEntity>> getAmenityCatalog() async {
    final list = await source.fetchAmenityCatalog();
    return list.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<AmenityEntity> addAmenity({required String name}) async {
    final m = await source.createAmenity(name: name);
    return m.toEntity();
  }
}


