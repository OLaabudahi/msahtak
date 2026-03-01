import '../../domain/entities/offer_entity.dart';

class OfferModel {
  final String id;
  final String title;
  final String percent;
  final String duration;
  final String terms;
  final bool enabled;

  const OfferModel({
    required this.id,
    required this.title,
    required this.percent,
    required this.duration,
    required this.terms,
    required this.enabled,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        percent: (json['percent'] ?? '').toString(),
        duration: (json['duration'] ?? '').toString(),
        terms: (json['terms'] ?? '').toString(),
        enabled: (json['enabled'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'percent': percent,
        'duration': duration,
        'terms': terms,
        'enabled': enabled,
      };

  OfferEntity toEntity() => OfferEntity(id: id, title: title, percent: percent, duration: duration, terms: terms, enabled: enabled);
}
