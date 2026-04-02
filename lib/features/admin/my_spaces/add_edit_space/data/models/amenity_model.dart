import '../../domain/entities/amenity_entity.dart';

class AmenityModel {
  final String id;
  final String name;
  final bool selected;
  final bool isCustom;

  const AmenityModel({
    required this.id,
    required this.name,
    required this.selected,
    required this.isCustom,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) => AmenityModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        selected: (json['selected'] ?? false) == true,
        isCustom: (json['isCustom'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'selected': selected, 'isCustom': isCustom};

  AmenityEntity toEntity() => AmenityEntity(id: id, name: name, selected: selected, isCustom: isCustom);

  static AmenityModel fromEntity(AmenityEntity e) => AmenityModel(id: e.id, name: e.name, selected: e.selected, isCustom: e.isCustom);
}


