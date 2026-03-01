import '../entities/space_form_entity.dart';
import '../repos/add_edit_space_repo.dart';

class SaveSpaceUseCase {
  final AddEditSpaceRepo repo;
  const SaveSpaceUseCase(this.repo);

  Future<void> call({required SpaceFormEntity form}) => repo.saveSpace(form: form);
}
