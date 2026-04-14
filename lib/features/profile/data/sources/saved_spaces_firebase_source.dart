import '../../../search_results/domain/entities/space_entity.dart';
import '../../../space_details/data/models/space_details_model.dart';
import '../../../space_details/data/sources/space_details_firebase_source.dart';
import 'saved_spaces_source.dart';

class SavedSpacesFirebaseSource implements SavedSpacesSource {
  final SpaceDetailsFirebaseSource source;

  SavedSpacesFirebaseSource({
    SpaceDetailsFirebaseSource? source,
  }) : source = source ?? SpaceDetailsFirebaseSource();

  @override
  Future<List<SpaceEntity>> fetchSavedSpaces(List<String> favoriteIds) async {
    if (favoriteIds.isEmpty) return const [];
    final spaces = <SpaceEntity>[];
    for (final id in favoriteIds) {
      final details = await source.fetchSpaceDetails(id);
      spaces.add(_toSpaceEntity(details));
    }
    return spaces;
  }

  SpaceEntity _toSpaceEntity(SpaceDetails details) {
    return SpaceEntity(
      id: details.id,
      name: details.name,
      locationName: details.locationAddress,
      distanceKm: 0,
      pricePerDay: details.pricePerDay.toDouble(),
      rating: details.rating,
      tags: details.features.take(2).toList(growable: false),
      imageUrl: details.imageAssets.isEmpty ? null : details.imageAssets.first,
      workingHours: const {},
      amenities: details.features,
      paymentMethods: const [],
      totalSeats: 0,
      currentBookings: 0,
    );
  }
}
