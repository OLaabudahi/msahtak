import '../models/space_form_model.dart';

abstract class AddEditSpaceSource {
  Future<SpaceFormModel> fetchSpaceForm({required String? spaceId});
  Future<void> saveSpace({required SpaceFormModel form});
}
