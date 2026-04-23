import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../_shared/admin_session.dart';
import 'offers_source.dart';
import '../models/offer_model.dart';

/// مصدر Firebase للعروض — يقرأ/يكتب من offers collection
class OffersFirebaseSource implements OffersSource {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Future<List<OfferModel>> fetchOffers() async {
    await _runOneTimeOffersMigrationAndBootstrap();

    final uid = _auth.currentUser?.uid ?? AdminSession.userId;
    final adminSpaceIds = await _loadAdminSpaceIds(uid);

    Query<Map<String, dynamic>> query = _db.collection('offers');
    if (uid.isNotEmpty) {
      query = query.where('adminId', isEqualTo: uid);
    }

    final snap = await query.get();
    return snap.docs.where((doc) {
      if (adminSpaceIds.isEmpty) return true;
      final spaceId = (doc.data()['spaceId'] ?? '').toString();
      return spaceId.isEmpty || adminSpaceIds.contains(spaceId);
    }).map((doc) {
      final d = doc.data();
      d['id'] = doc.id;
      return OfferModel.fromJson(d);
    }).toList();
  }

  @override
  Future<void> toggleOffer({required String offerId, required bool enabled}) async {
    await _db.collection('offers').doc(offerId).update({'enabled': enabled});
  }

  @override
  Future<void> createOffer({required OfferModel offer}) async {
    final data = offer.toJson();
    data.remove('id');

    final adminId =
        offer.adminId ?? _auth.currentUser?.uid ?? 'DUMMY_ADMIN_EDIT_ME';
    final spaceId =
        offer.spaceId ??
        await _resolveAdminDefaultSpaceId(adminId) ??
        'DUMMY_SPACE_ID_EDIT_ME';

    data['adminId'] = adminId;
    data['spaceId'] = spaceId;

    Map<String, dynamic>? spaceData;
    try {
      final spaceSnap = await _db.collection('spaces').doc(spaceId).get();
      spaceData = spaceSnap.data();
    } catch (_) {}

    final spaceName = (spaceData?['name'] ?? spaceData?['spaceName'] ?? offer.title).toString();
    final location = (spaceData?['address'] ?? spaceData?['locationAddress'] ?? '').toString();
    final originalPrice = (spaceData?['basePriceValue'] as num?)?.toInt() ??
        (spaceData?['pricePerDay'] as num?)?.toInt() ??
        0;

    final discountPercent = (offer.discountPercent ?? 0).round();
    final discountedPrice = (offer.fixedPriceValue ?? 0) > 0
        ? offer.fixedPriceValue!.round()
        : (discountPercent > 0 && originalPrice > 0)
            ? (originalPrice * (100 - discountPercent) / 100).round()
            : originalPrice;

    data['name'] = spaceName;
    data['spaceName'] = spaceName;
    data['location'] = location;
    data['originalPrice'] = originalPrice;
    data['discountedPrice'] = discountedPrice;
    data['discountPercent'] = discountPercent;
    data['createdAt'] = FieldValue.serverTimestamp();

    await _db.collection('offers').add(data);
  }

  Future<Set<String>> _loadAdminSpaceIds(String uid) async {
    if (uid.isEmpty) return <String>{};
    final fromSession = AdminSession.assignedSpaceIds
        .where((e) => e.trim().isNotEmpty)
        .toSet();
    if (fromSession.isNotEmpty) return fromSession;

    try {
      final snap = await _db
          .collection('spaces')
          .where('adminId', isEqualTo: uid)
          .get();
      return snap.docs.map((d) => d.id).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<String?> _resolveAdminDefaultSpaceId(String adminId) async {
    final ids = await _loadAdminSpaceIds(adminId);
    if (ids.isNotEmpty) return ids.first;
    try {
      final spacesSnap = await _db
          .collection('spaces')
          .where('adminId', isEqualTo: adminId)
          .limit(1)
          .get();
      if (spacesSnap.docs.isNotEmpty) {
        return spacesSnap.docs.first.id;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _runOneTimeOffersMigrationAndBootstrap() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final migrationMarker = _db.collection('app_meta').doc('offers_migration_v1_done');
    final migrationSnap = await migrationMarker.get();

    if (!migrationSnap.exists) {
      final spacesSnap = await _db.collection('spaces').get();
      final batch = _db.batch();

      for (final doc in spacesSnap.docs) {
        final d = doc.data();
        final spaceId = doc.id;
        final adminId = (d['adminId'] ?? 'DUMMY_ADMIN_EDIT_ME').toString();
        final spaceName = (d['name'] ?? d['spaceName'] ?? 'Space').toString();
        final location = (d['address'] ?? '').toString();
        final originalPrice = (d['basePriceValue'] as num?)?.toInt() ??
            (d['pricePerDay'] as num?)?.toInt() ??
            0;
        final rawOffers = (d['offers'] as List?) ?? const [];

        for (final item in rawOffers) {
          if (item is! Map) continue;
          final map = Map<String, dynamic>.from(item);
          final legacyId = (map['id'] ?? '').toString().trim();
          if (legacyId.isEmpty) continue;

          final newDocId = 'legacy_${spaceId}_$legacyId';
          final discountPercent = (map['discountPercent'] as num?)?.toInt() ?? 0;
          final discountedPrice = (map['fixedPriceValue'] as num?)?.toInt() ??
              (map['new_price_value'] as num?)?.toInt() ??
              (discountPercent > 0 && originalPrice > 0
                  ? (originalPrice * (100 - discountPercent) / 100).round()
                  : originalPrice);

          batch.set(_db.collection('offers').doc(newDocId), {
            ...map,
            'id': newDocId,
            'spaceId': spaceId,
            'adminId': adminId,
            'title': (map['title'] ?? legacyId).toString(),
            'name': spaceName,
            'location': location,
            'originalPrice': originalPrice,
            'discountedPrice': discountedPrice,
            'discountPercent': discountPercent,
            'enabled': map['enabled'] ?? true,
            'migratedFromSpaceOffers': true,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        // TEMP: requested by product to remove embedded offers after migration.
        batch.update(doc.reference, {
          'offers': [],
          'offersMigratedAt': FieldValue.serverTimestamp(),
        });
      }

      batch.set(migrationMarker, {
        'done': true,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();
    }

    // TEMP BOOTSTRAP (remove later after first successful run)
    final bootstrapMarker = _db.collection('app_meta').doc('offers_bootstrap_admin_${uid}_v1_done');
    final bootSnap = await bootstrapMarker.get();
    if (bootSnap.exists) return;

    final adminSpaces = await _db.collection('spaces').where('adminId', isEqualTo: uid).get();
    final batch = _db.batch();

    for (final spaceDoc in adminSpaces.docs) {
      final spaceId = spaceDoc.id;
      final d = spaceDoc.data();
      final name = (d['name'] ?? d['spaceName'] ?? 'Space').toString();
      final location = (d['address'] ?? '').toString();
      final base = (d['basePriceValue'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          0;

      final existing = await _db
          .collection('offers')
          .where('spaceId', isEqualTo: spaceId)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) continue;

      final offerAId = 'bootstrap_${spaceId}_disc10';
      final offerBId = 'bootstrap_${spaceId}_week';

      batch.set(_db.collection('offers').doc(offerAId), {
        'id': offerAId,
        'spaceId': spaceId,
        'adminId': uid,
        'title': '10% OFF (Edit me)',
        'type': 'discountPercent',
        'discountPercent': 10,
        'enabled': true,
        'name': name,
        'location': location,
        'originalPrice': base,
        'discountedPrice': (base * 0.9).round(),
        'validUntil': '2099-12-31',
        'createdAt': FieldValue.serverTimestamp(),
        'bootstrap': true,
      }, SetOptions(merge: true));

      batch.set(_db.collection('offers').doc(offerBId), {
        'id': offerBId,
        'spaceId': spaceId,
        'adminId': uid,
        'title': 'Weekly package (Edit me)',
        'type': 'packageMonths',
        'durationValue': 7,
        'durationUnit': 'days',
        'discountPercent': 15,
        'enabled': true,
        'name': name,
        'location': location,
        'originalPrice': base,
        'discountedPrice': (base * 0.85).round(),
        'validUntil': '2099-12-31',
        'createdAt': FieldValue.serverTimestamp(),
        'bootstrap': true,
      }, SetOptions(merge: true));
    }

    batch.set(bootstrapMarker, {
      'done': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await batch.commit();
  }
}
