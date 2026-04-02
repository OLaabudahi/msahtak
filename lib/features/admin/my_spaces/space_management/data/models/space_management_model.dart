import '../../domain/entities/space_management_entity.dart';

class SpaceManagementModel {
  final String id;
  final String name;
  final bool hidden;

  const SpaceManagementModel({
    required this.id,
    required this.name,
    required this.hidden,
  });

  factory SpaceManagementModel.fromJson(Map<String, dynamic> json) => SpaceManagementModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        hidden: (json['hidden'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'hidden': hidden};

  SpaceManagementEntity toEntity() => SpaceManagementEntity(id: id, name: name, hidden: hidden);
}


