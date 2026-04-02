import '../../domain/entities/day_availability_entity.dart';

class DayAvailabilityModel {
  final String dayId;
  final bool closed;
  final String specialHours;

  const DayAvailabilityModel({
    required this.dayId,
    required this.closed,
    required this.specialHours,
  });

  factory DayAvailabilityModel.fromJson(Map<String, dynamic> json) => DayAvailabilityModel(
        dayId: (json['dayId'] ?? '').toString(),
        closed: (json['closed'] ?? false) == true,
        specialHours: (json['specialHours'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'dayId': dayId, 'closed': closed, 'specialHours': specialHours};

  DayAvailabilityEntity toEntity() => DayAvailabilityEntity(dayId: dayId, closed: closed, specialHours: specialHours);
}


