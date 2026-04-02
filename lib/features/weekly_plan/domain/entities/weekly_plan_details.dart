import 'package:equatable/equatable.dart';

class WeeklyPlanDetails extends Equatable {
  final String hubId;
  final String hubName;
  final int pricePerWeek;
  final List<String> features;
  final String tip;

  const WeeklyPlanDetails({
    required this.hubId,
    required this.hubName,
    required this.pricePerWeek,
    required this.features,
    required this.tip,
  });

  @override
  List<Object?> get props =>
      [hubId, hubName, pricePerWeek, features, tip];
}


