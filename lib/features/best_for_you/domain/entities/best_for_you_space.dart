import 'package:equatable/equatable.dart';

class BestForYouSpace extends Equatable {
  final String id;
  final String name;
  final String location;
  final String distance;
  final int pricePerDay;
  final double rating;
  final String? imageUrl;

  const BestForYouSpace({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.pricePerDay,
    required this.rating,
    this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, location, distance, pricePerDay, rating, imageUrl];
}
