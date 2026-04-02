import '../../domain/entities/best_for_you_space.dart';

class BestForYouSpaceModel extends BestForYouSpace {
  const BestForYouSpaceModel({
    required super.id,
    required super.name,
    required super.location,
    required super.distance,
    required super.pricePerDay,
    required super.rating,
    super.imageUrl,
  });

  factory BestForYouSpaceModel.fromJson(
      Map<String, dynamic> json) {
    return BestForYouSpaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      distance: json['distance'] as String,
      pricePerDay: json['pricePerDay'] as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}


