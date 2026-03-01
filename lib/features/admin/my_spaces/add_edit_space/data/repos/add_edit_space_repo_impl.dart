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
    final model = SpaceFormModel(
      id: form.id,
      name: form.name,
      address: form.address,
      price: form.price,
      description: form.description,
      amenities: form.amenities.map((a) => {'id': a.id, 'name': a.name, 'selected': a.selected}).toList(growable: false),
      hours: form.hours,
      policies: form.policies,
      hidden: form.hidden,
    );
    return source.saveSpace(form: model);
  }
}
