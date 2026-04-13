import 'package:equatable/equatable.dart';

class SpaceEntity extends Equatable {
  final String id;
  final String name;
  final String locationName;
  final double distanceKm;
  final double pricePerDay;
  final double rating;
  final List<String> tags;
  final String? imageUrl;
  final Map<String, dynamic> workingHours;
  final List<String> amenities;
  final List<String> paymentMethods;
  final int totalSeats;
  final int currentBookings;

  const SpaceEntity({
    required this.id,
    required this.name,
    required this.locationName,
    required this.distanceKm,
    required this.pricePerDay,
    required this.rating,
    required this.tags,
    this.imageUrl,
    this.workingHours = const {},
    this.amenities = const [],
    this.paymentMethods = const [],
    this.totalSeats = 0,
    this.currentBookings = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        locationName,
        distanceKm,
        pricePerDay,
        rating,
        tags,
        imageUrl,
        workingHours,
        amenities,
        paymentMethods,
        totalSeats,
        currentBookings,
      ];
}
