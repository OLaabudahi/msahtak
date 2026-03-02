import '../../domain/entities/space_form_entity.dart';
import '../../domain/entities/price_unit.dart';
import '../models/amenity_model.dart';
import '../models/policy_section_model.dart';
import '../models/price_unit_model.dart';
import '../models/space_location_model.dart';
import '../models/working_hours_model.dart';

class SpaceFormModel {
  final String? id;

  final String name;
  final String address;
  final String description;

  // OLD compatibility fields
  final String price;
  final String hours;
  final String policies;

  // NEW
  final double basePriceValue;
  final String basePriceUnit; // day|week|month

  final Map<String, dynamic>? location; // {lat,lng}
  final List<Map<String, dynamic>> workingHours; // list
  final List<Map<String, dynamic>> policySections; // list
  final List<Map<String, dynamic>> amenities; // list

  final bool hidden;

  const SpaceFormModel({
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
    required this.hidden,
  });

  factory SpaceFormModel.fromJson(Map<String, dynamic> json) => SpaceFormModel(
        id: json['id']?.toString(),
        name: (json['name'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        price: (json['price'] ?? '').toString(),
        hours: (json['hours'] ?? '').toString(),
        policies: (json['policies'] ?? '').toString(),
        basePriceValue: (json['basePriceValue'] as num?)?.toDouble() ?? 0,
        basePriceUnit: (json['basePriceUnit'] ?? 'day').toString(),
        location: (json['location'] as Map?)?.cast<String, dynamic>(),
        workingHours: (json['workingHours'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList(growable: false) ?? const [],
        policySections: (json['policySections'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList(growable: false) ?? const [],
        amenities: (json['amenities'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList(growable: false) ?? const [],
        hidden: (json['hidden'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'description': description,
        'price': price,
        'hours': hours,
        'policies': policies,
        'basePriceValue': basePriceValue,
        'basePriceUnit': basePriceUnit,
        'location': location,
        'workingHours': workingHours,
        'policySections': policySections,
        'amenities': amenities,
        'hidden': hidden,
      };

  SpaceFormEntity toEntity() {
    final unit = PriceUnitModel.fromJson(basePriceUnit);

    final loc = (location == null) ? null : SpaceLocationModel.fromJson(location!).toEntity();

    final wh = workingHours.map((m) => WorkingHoursModel.fromJson(m).toEntity()).toList(growable: false);
    final ps = policySections.map((m) => PolicySectionModel.fromJson(m).toEntity()).toList(growable: false);
    final am = amenities.map((m) => AmenityModel.fromJson(m).toEntity()).toList(growable: false);

    return SpaceFormEntity(
      id: id,
      name: name,
      address: address,
      description: description,
      price: price,
      hours: hours,
      policies: policies,
      basePriceValue: basePriceValue,
      basePriceUnit: unit,
      location: loc,
      workingHours: wh,
      policySections: ps,
      amenities: am,
      hidden: hidden,
    );
  }

  static SpaceFormModel fromEntity(SpaceFormEntity e) {
    final loc = e.location == null ? null : SpaceLocationModel.fromEntity(e.location!).toJson();

    return SpaceFormModel(
      id: e.id,
      name: e.name,
      address: e.address,
      description: e.description,
      price: e.price,
      hours: e.hours,
      policies: e.policies,
      basePriceValue: e.basePriceValue,
      basePriceUnit: PriceUnitModel.toJson(e.basePriceUnit),
      location: loc,
      workingHours: e.workingHours.map((x) => WorkingHoursModel.fromEntity(x).toJson()).toList(growable: false),
      policySections: e.policySections.map((x) => PolicySectionModel.fromEntity(x).toJson()).toList(growable: false),
      amenities: e.amenities.map((x) => AmenityModel.fromEntity(x).toJson()).toList(growable: false),
      hidden: e.hidden,
    );
  }
}
