import '../../domain/entities/plan_option.dart';

class PlanOptionModel extends PlanOption {
  const PlanOptionModel({
    required super.id,
    required super.name,
    required super.priceLabel,
    super.isBest,
  });

  factory PlanOptionModel.fromJson(Map<String, dynamic> json) {
    return PlanOptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      priceLabel: json['priceLabel'] as String,
      isBest: json['isBest'] as bool? ?? false,
    );
  }
}


