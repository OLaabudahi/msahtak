import '../../domain/entities/admin_space_summary_entity.dart';

class AdminSpaceSummaryModel {
  final String id;
  final String name;

  const AdminSpaceSummaryModel({
    required this.id,
    required this.name,
  });

  factory AdminSpaceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminSpaceSummaryModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  AdminSpaceSummaryEntity toEntity() {
    return AdminSpaceSummaryEntity(id: id, name: name);
  }
}

