import 'package:equatable/equatable.dart';
import 'amenity_entity.dart';
import 'policy_section_entity.dart';
import 'price_unit.dart';
import 'space_location_entity.dart';
import 'working_hours_entity.dart';

class SpaceFormEntity extends Equatable {
  final String? id;

  
  final String name;
  final String address; 
  final String description; 

  
  final String price;    
  final String hours;    
  final String policies; 

  
  final double basePriceValue;
  final PriceUnit basePriceUnit;

  final SpaceLocationEntity? location; 
  final List<WorkingHoursEntity> workingHours;
  final List<PolicySectionEntity> policySections;

  final List<AmenityEntity> amenities;

  
  final List<String> images;

  
  final bool hidden;

  
  final int totalSeats;

  
  final String? adminId;
  final String? adminName;

  
  final List<Map<String, String>> paymentMethods;

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
    this.paymentMethods = const [],
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
        paymentMethods,
      ];
}


