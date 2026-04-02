import 'package:equatable/equatable.dart';

class AnalyticsEntity extends Equatable {
  final String occupancy;
  final String revenue;
  final String avgRating;

  final List<String> weekLabels;
  final List<String> weekValues;

  final List<String> topSpaces; 

  const AnalyticsEntity({
    required this.occupancy,
    required this.revenue,
    required this.avgRating,
    required this.weekLabels,
    required this.weekValues,
    required this.topSpaces,
  });

  @override
  List<Object?> get props => [occupancy, revenue, avgRating, weekLabels, weekValues, topSpaces];
}
