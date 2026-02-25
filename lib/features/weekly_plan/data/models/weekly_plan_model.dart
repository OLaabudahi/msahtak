import '../../domain/entities/weekly_plan_details.dart';

class WeeklyPlanModel extends WeeklyPlanDetails {
  const WeeklyPlanModel({
    required super.hubId,
    required super.hubName,
    required super.pricePerWeek,
    required super.features,
    required super.tip,
  });

  factory WeeklyPlanModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanModel(
      hubId: json['hubId'] as String,
      hubName: json['hubName'] as String,
      pricePerWeek: json['pricePerWeek'] as int,
      features: List<String>.from(json['features'] as List),
      tip: json['tip'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'hubId': hubId,
        'hubName': hubName,
        'pricePerWeek': pricePerWeek,
        'features': features,
        'tip': tip,
      };
}
