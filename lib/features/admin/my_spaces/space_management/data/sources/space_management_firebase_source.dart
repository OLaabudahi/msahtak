import 'package:cloud_firestore/cloud_firestore.dart';
import 'space_management_source.dart';
import '../models/space_management_model.dart';

/// ظ…طµط¯ط± Firebase ظ„ط¥ط¯ط§ط±ط© ط§ظ„ظ…ط³ط§ط­ط§طھ â€” ظٹظ‚ط±ط£/ظٹظƒطھط¨ ظ…ظ† spaces collection
class SpaceManagementFirebaseSource implements SpaceManagementSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<SpaceManagementModel> fetchSpace({required String spaceId}) async {
    final doc = await _db.collection('spaces').doc(spaceId).get();
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
    await _db.collection('spaces').doc(spaceId).update({'hidden': hidden});
  }
}


