import '../../domain/entities/filter_chip_entity.dart';

class FilterChipModel {
  final String id;
  final String label;

  const FilterChipModel({required this.id, required this.label});

  factory FilterChipModel.fromJson(Map<String, dynamic> json) {
    return FilterChipModel(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'label': label};

  FilterChipEntity toEntity() => FilterChipEntity(id: id, label: label);
}
