import '../entities/space_form_entity.dart';
import '../repos/add_edit_space_repo.dart';

class GetSpaceFormUseCase {
  final AddEditSpaceRepo repo;
  const GetSpaceFormUseCase(this.repo);

  Future<SpaceFormEntity> call({required String? spaceId}) => repo.getSpaceForm(spaceId: spaceId);
}


