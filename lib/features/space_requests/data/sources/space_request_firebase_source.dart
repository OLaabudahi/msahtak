import '../../../../core/services/firestore_api.dart';
import '../models/space_request_model.dart';
import 'space_request_source.dart';

class SpaceRequestFirebaseSource implements SpaceRequestSource {
  final FirestoreApi api;

  SpaceRequestFirebaseSource(this.api);

  @override
  Future<void> submitRequest(SpaceRequestModel model) async {
    await api.create(
      collection: 'spaceRequests',
      docId: model.requestId,
      data: model.toMap(),
    );
  }
}
