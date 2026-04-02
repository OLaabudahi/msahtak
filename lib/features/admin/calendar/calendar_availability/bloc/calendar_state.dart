import 'package:equatable/equatable.dart';
import '../domain/entities/day_availability_entity.dart';

enum CalendarStatus { initial, loading, ready, saving, saved, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;
  final DayAvailabilityEntity? day;
  final String? error;

  const CalendarState({
    required this.status,
    required this.day,
    required this.error,
  });

  factory CalendarState.initial() => const CalendarState(status: CalendarStatus.initial, day: null, error: null);

  CalendarState copyWith({CalendarStatus? status, DayAvailabilityEntity? day, String? error}) {
    return CalendarState(status: status ?? this.status, day: day ?? this.day, error: error);
  }

  @override
  List<Object?> get props => [status, day, error];
}


