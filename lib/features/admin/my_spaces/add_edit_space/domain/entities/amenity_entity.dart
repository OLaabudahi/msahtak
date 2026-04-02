import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  final String id;
  final String name;
  final bool selected;

  // NEW (API-ready): amenity can be created from admin
  final bool isCustom;

  const AmenityEntity({
    required this.id,
    required this.name,
    required this.selected,
    required this.isCustom,
  });

  @override
  List<Object?> get props => [id, name, selected, isCustom];
}


