import '../../domain/entities/analytics_entity.dart';

class AnalyticsModel {
  final String occupancy;
  final String revenue;
  final String avgRating;
  final List<String> weekLabels;
  final List<String> weekValues;
  final List<String> topSpaces;

  const AnalyticsModel({
    required this.occupancy,
    required this.revenue,
    required this.avgRating,
    required this.weekLabels,
    required this.weekValues,
    required this.topSpaces,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
        occupancy: (json['occupancy'] ?? '').toString(),
        revenue: (json['revenue'] ?? '').toString(),
        avgRating: (json['avgRating'] ?? '').toString(),
        weekLabels: (json['weekLabels'] as List?)?.map((e) => e.toString()).toList(growable: false) ?? const [],
        weekValues: (json['weekValues'] as List?)?.map((e) => e.toString()).toList(growable: false) ?? const [],
        topSpaces: (json['topSpaces'] as List?)?.map((e) => e.toString()).toList(growable: false) ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'occupancy': occupancy,
        'revenue': revenue,
        'avgRating': avgRating,
        'weekLabels': weekLabels,
        'weekValues': weekValues,
        'topSpaces': topSpaces,
      };

  AnalyticsEntity toEntity() => AnalyticsEntity(
        occupancy: occupancy,
        revenue: revenue,
        avgRating: avgRating,
        weekLabels: weekLabels,
        weekValues: weekValues,
        topSpaces: topSpaces,
      );
}


