import 'package:equatable/equatable.dart';
import 'amenity_entity.dart';
import 'policy_section_entity.dart';
import 'price_unit.dart';
import 'space_location_entity.dart';
import 'working_hours_entity.dart';

class SpaceFormEntity extends Equatable {
  final String? id;

  // Basic
  final String name;
  final String address; // keep (text)
  final String description; // keep (optional)

  // OLD compatibility (UI currently uses these)
  final String price;    // keep
  final String hours;    // keep
  final String policies; // keep

  // NEW structured fields (API-ready)
  final double basePriceValue;
  final PriceUnit basePriceUnit;

  final SpaceLocationEntity? location; // lat/lng
  final List<WorkingHoursEntity> workingHours;
  final List<PolicySectionEntity> policySections;

  final List<AmenityEntity> amenities;

  // Images (list of URLs)
  final List<String> images;

  // Availability
  final bool hidden;

  // Seats
  final int totalSeats;

  // Sub Admin
  final String? adminId;
  final String? adminName;

  const SpaceFormEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.price,
    required this.hours,
    required this.policies,
    required this.basePriceValue,
    required this.basePriceUnit,
    required this.location,
    required this.workingHours,
    required this.policySections,
    required this.amenities,
    this.images = const [],
    required this.hidden,
    this.totalSeats = 0,
    this.adminId,
    this.adminName,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        description,
        price,
        hours,
        policies,
        basePriceValue,
        basePriceUnit,
        location,
        workingHours,
        policySections,
        amenities,
        images,
        hidden,
        totalSeats,
        adminId,
        adminName,
      ];
}
