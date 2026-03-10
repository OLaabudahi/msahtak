import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_spaces_source.dart';
import '../models/space_model.dart';

/// مصدر Firebase لمساحات الأدمن — يقرأ من workspaces collection
class MySpacesFirebaseSource implements MySpacesSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<SpaceModel>> fetchSpaces() async {
    final snap = await _db.collection('workspaces').get();

    return snap.docs.map((doc) {
      final d = doc.data();
      final name = d['spaceName'] as String? ?? d['name'] as String? ?? 'Space';
      final stats = d['stats'] as Map<String, dynamic>?;
      final rating = (d['rating'] as num?)?.toDouble() ??
          (stats?['averageRating'] as num?)?.toDouble() ?? 0.0;
      final isActive = d['isActive'] as bool? ??
          d['visible'] as bool? ?? true;
      final cover = d['imageUrl'] as String? ??
          d['cover'] as String? ??
          d['thumbnailUrl'] as String? ?? '';
      return SpaceModel(
        id: doc.id,
        name: name,
        rating: rating.toStringAsFixed(1),
        availability: isActive ? 'available' : 'hidden',
        cover: cover,
      );
    }).toList();
  }

  @override
  Future<void> hideSpace({required String spaceId}) async {
    final doc = await _db.collection('workspaces').doc(spaceId).get();
    final current = doc.data()?['isActive'] as bool? ?? true;
    await _db.collection('workspaces').doc(spaceId).update({
      'isActive': !current,
      'visible': !current,
    });
  }

  @override
  Future<void> deleteSpace({required String spaceId}) =>
      _db.collection('workspaces').doc(spaceId).delete();
}
