import '../../domain/entities/week_day.dart';

class WeekDayModel {
  static String toJson(WeekDay d) => d.name;

  static WeekDay fromJson(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'mon': return WeekDay.mon;
      case 'tue': return WeekDay.tue;
      case 'wed': return WeekDay.wed;
      case 'thu': return WeekDay.thu;
      case 'fri': return WeekDay.fri;
      case 'sat': return WeekDay.sat;
      default: return WeekDay.sun;
    }
  }
}
