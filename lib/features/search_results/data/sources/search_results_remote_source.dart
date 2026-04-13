import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchResultsRemoteSource {
  Future<List<Map<String, dynamic>>> searchSpacesRaw({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  });

  Future<List<Map<String, dynamic>>> preferredChipsRaw({
    required String originKey,
  });
}

class SearchResultsFirebaseSource implements SearchResultsRemoteSource {
  final FirebaseFirestore db;

  SearchResultsFirebaseSource({FirebaseFirestore? db})
      : db = db ?? FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> searchSpacesRaw({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    Query<Map<String, dynamic>> q = db.collection('spaces').limit(100);

    final minPrice = (selectedFilters['priceMin'] as num?)?.toDouble();
    final maxPrice = (selectedFilters['priceMax'] as num?)?.toDouble();
    final city = (selectedFilters['city'] ?? '').toString().trim();
    final amenities = (selectedFilters['amenities'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[];

    if (minPrice != null) {
      q = q.where('basePriceValue', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      q = q.where('basePriceValue', isLessThanOrEqualTo: maxPrice);
    }
    if (amenities.isNotEmpty) {
      q = q.where('amenities', arrayContainsAny: amenities.take(10).toList());
    }

    final snap = await q.get();

    return snap.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id,
            })
        .where((d) {
          if (city.isEmpty) return true;
          final location = (d['locationAddress'] ?? d['address'] ?? d['city'] ?? d['location_name'] ?? '').toString().toLowerCase();
          return location.contains(city.toLowerCase());
        })
        .toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> preferredChipsRaw({required String originKey}) async {
    return const <Map<String, dynamic>>[];
  }
}
