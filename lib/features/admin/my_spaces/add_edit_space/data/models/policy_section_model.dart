import '../../domain/entities/policy_section_entity.dart';

class PolicySectionModel {
  final String id;
  final String title;
  final List<String> bullets;

  const PolicySectionModel({
    required this.id,
    required this.title,
    required this.bullets,
  });

  factory PolicySectionModel.fromJson(Map<String, dynamic> json) => PolicySectionModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        bullets: (json['bullets'] as List?)?.map((e) => e.toString()).toList(growable: false) ?? const [],
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'bullets': bullets};

  PolicySectionEntity toEntity() => PolicySectionEntity(id: id, title: title, bullets: bullets);

  static PolicySectionModel fromEntity(PolicySectionEntity e) => PolicySectionModel(id: e.id, title: e.title, bullets: e.bullets);
}
