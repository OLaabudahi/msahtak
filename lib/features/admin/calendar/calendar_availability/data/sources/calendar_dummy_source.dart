import 'calendar_source.dart';
import '../models/day_availability_model.dart';

class CalendarDummySource implements CalendarSource {
  DayAvailabilityModel _day = const DayAvailabilityModel(dayId: '2026-03-01', closed: false, specialHours: '');

  @override
  Future<DayAvailabilityModel> fetchDay({required String dayId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return DayAvailabilityModel(dayId: dayId, closed: _day.closed, specialHours: _day.specialHours);
  }

  @override
  Future<void> saveDay({required DayAvailabilityModel day}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    _day = day;
  }
}


