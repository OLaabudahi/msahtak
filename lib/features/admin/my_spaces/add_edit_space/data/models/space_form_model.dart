import '../../domain/entities/amenity_entity.dart';
import '../../domain/entities/space_form_entity.dart';

class SpaceFormModel {
  final String? id;
  final String name;
  final String address;
  final String price;
  final String description;
  final List<Map<String, dynamic>> amenities;
  final String hours;
  final String policies;

  // NEW:
  final bool hidden;

  const SpaceFormModel({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.description,
    required this.amenities,
    required this.hours,
    required this.policies,
    required this.hidden,
  });

  factory SpaceFormModel.fromJson(Map<String, dynamic> json) => SpaceFormModel(
        id: json['id']?.toString(),
        name: (json['name'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
        price: (json['price'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        amenities: (json['amenities'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
        hours: (json['hours'] ?? '').toString(),
        policies: (json['policies'] ?? '').toString(),
        hidden: (json['hidden'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'price': price,
        'description': description,
        'amenities': amenities,
        'hours': hours,
        'policies': policies,
        'hidden': hidden,
      };

  SpaceFormEntity toEntity() => SpaceFormEntity(
        id: id,
        name: name,
        address: address,
        price: price,
        description: description,
        amenities: amenities
            .map((a) => AmenityEntity(
                  id: (a['id'] ?? '').toString(),
                  name: (a['name'] ?? '').toString(),
                  selected: (a['selected'] ?? false) == true,
                ))
            .toList(growable: false),
        hours: hours,
        policies: policies,
        hidden: hidden,
      );
}
