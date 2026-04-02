import 'package:equatable/equatable.dart';

class DayAvailabilityEntity extends Equatable {
  final String dayId; 
  final bool closed;
  final String specialHours;

  const DayAvailabilityEntity({
    required this.dayId,
    required this.closed,
    required this.specialHours,
  });

  @override
  List<Object?> get props => [dayId, closed, specialHours];
}


