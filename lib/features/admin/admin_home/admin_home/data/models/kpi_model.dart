import '../../domain/entities/kpi_entity.dart';

class KpiModel {
  final String id;
  final String title;
  final String value;
  final String delta;

  const KpiModel({
    required this.id,
    required this.title,
    required this.value,
    required this.delta,
  });

  factory KpiModel.fromJson(Map<String, dynamic> json) => KpiModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        value: (json['value'] ?? '').toString(),
        delta: (json['delta'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'value': value, 'delta': delta};

  KpiEntity toEntity() => KpiEntity(id: id, title: title, value: value, delta: delta);
}


