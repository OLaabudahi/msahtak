import 'package:equatable/equatable.dart';

class UsageStats extends Equatable {
  final int totalBookings;
  final int totalHours;
  final double avgHoursPerSession;
  final String mostCommonTime;
  final List<String> insights;
  final String recommendation;

  const UsageStats({
    required this.totalBookings,
    required this.totalHours,
    required this.avgHoursPerSession,
    required this.mostCommonTime,
    required this.insights,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
        totalBookings,
        totalHours,
        avgHoursPerSession,
        mostCommonTime,
        insights,
        recommendation,
      ];
}


