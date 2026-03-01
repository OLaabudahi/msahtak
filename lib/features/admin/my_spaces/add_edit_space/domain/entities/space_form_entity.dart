import 'package:equatable/equatable.dart';
import 'amenity_entity.dart';

class SpaceFormEntity extends Equatable {
  final String? id;
  final String name;
  final String address;
  final String price;
  final String description;
  final List<AmenityEntity> amenities;
  final String hours;
  final String policies;

  // NEW:
  final bool hidden;

  const SpaceFormEntity({
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

  @override
  List<Object?> get props => [id, name, address, price, description, amenities, hours, policies, hidden];
}
