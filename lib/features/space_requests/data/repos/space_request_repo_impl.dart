import '../../domain/entities/space_request_entity.dart';
import '../../domain/repos/space_request_repo.dart';
import '../models/space_request_model.dart';
import '../sources/space_request_firebase_source.dart';

class SpaceRequestRepoImpl implements SpaceRequestRepo {
  final SpaceRequestFirebaseSource source;

  SpaceRequestRepoImpl(this.source);

  @override
  Future<void> submitRequest(SpaceRequestEntity request) async {
    final model = SpaceRequestModel(
      idRequest: request.idRequest,
      nameSpace: request.nameSpace,
      descriptionSpace: request.descriptionSpace,
      locationDes: request.locationDes,
      phoneNo: request.phoneNo,
      whatsAppNo: request.whatsAppNo,
      contactName: request.contactName,
      pricePerDay: request.pricePerDay,
      capacity: request.capacity,
      workingHours: request.workingHours,
      createdAt: request.createdAt,
    );
    await source.submitRequest(model);
  }
}


