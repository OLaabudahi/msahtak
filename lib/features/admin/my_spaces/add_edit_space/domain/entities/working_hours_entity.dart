import 'package:equatable/equatable.dart';
import 'week_day.dart';

class WorkingHoursEntity extends Equatable {
  final WeekDay day;
  final String open;  // "08:00"
  final String close; // "22:00"
  final bool closed;

  const WorkingHoursEntity({
    required this.day,
    required this.open,
    required this.close,
    required this.closed,
  });

  @override
  List<Object?> get props => [day, open, close, closed];
}
