import '../../domain/entities/working_hours_entity.dart';
import '../../domain/entities/week_day.dart';
import 'week_day_model.dart';

class WorkingHoursModel {
  final String day; 
  final String open;
  final String close;
  final bool closed;

  const WorkingHoursModel({
    required this.day,
    required this.open,
    required this.close,
    required this.closed,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) => WorkingHoursModel(
        day: (json['day'] ?? 'sun').toString(),
        open: (json['open'] ?? '08:00').toString(),
        close: (json['close'] ?? '22:00').toString(),
        closed: (json['closed'] ?? false) == true,
      );

  Map<String, dynamic> toJson() => {'day': day, 'open': open, 'close': close, 'closed': closed};

  WorkingHoursEntity toEntity() => WorkingHoursEntity(
        day: WeekDayModel.fromJson(day),
        open: open,
        close: close,
        closed: closed,
      );

  static WorkingHoursModel fromEntity(WorkingHoursEntity e) => WorkingHoursModel(
        day: WeekDayModel.toJson(e.day),
        open: e.open,
        close: e.close,
        closed: e.closed,
      );
}


