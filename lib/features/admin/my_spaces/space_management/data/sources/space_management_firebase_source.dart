import 'package:cloud_firestore/cloud_firestore.dart';
import 'space_management_source.dart';
import '../models/space_management_model.dart';

/// مصدر Firebase لإدارة المساحات — يقرأ/يكتب من spaces collection
class SpaceManagementFirebaseSource implements SpaceManagementSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<SpaceManagementModel> fetchSpace({required String spaceId}) async {
    final doc = await _db.collection('workspaces').doc(spaceId).get();
    if (!doc.exists) {
      return SpaceManagementModel(id: spaceId, name: 'Unknown Space', hidden: false);
    }
    final d = doc.data()!;
    return SpaceManagementModel(
      id: doc.id,
      name: d['name'] as String? ?? '',
      hidden: d['hidden'] as bool? ?? false,
    );
  }

  @override
  Future<void> setHidden({required String spaceId, required bool hidden}) async {
    await _db.collection('workspaces').doc(spaceId).update({'hidden': hidden});
  }
}
