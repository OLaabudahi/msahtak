import '../models/day_availability_model.dart';

abstract class CalendarSource {
  Future<DayAvailabilityModel> fetchDay({required String dayId});
  Future<void> saveDay({required DayAvailabilityModel day});
}


