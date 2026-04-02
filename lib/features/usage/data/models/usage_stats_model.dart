import '../../domain/entities/usage_stats.dart';

class UsageStatsModel extends UsageStats {
  const UsageStatsModel({
    required super.totalBookings,
    required super.totalHours,
    required super.avgHoursPerSession,
    required super.mostCommonTime,
    required super.insights,
    required super.recommendation,
  });

  factory UsageStatsModel.fromJson(Map<String, dynamic> json) {
    return UsageStatsModel(
      totalBookings: json['totalBookings'] as int,
      totalHours: json['totalHours'] as int,
      avgHoursPerSession:
          (json['avgHoursPerSession'] as num).toDouble(),
      mostCommonTime: json['mostCommonTime'] as String,
      insights: List<String>.from(json['insights'] as List),
      recommendation: json['recommendation'] as String,
    );
  }
}


