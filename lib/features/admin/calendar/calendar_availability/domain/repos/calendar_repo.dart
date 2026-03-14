import '../entities/day_availability_entity.dart';

abstract class CalendarRepo {
  Future<DayAvailabilityEntity> getDay({required String dayId});
  Future<void> saveDay({required DayAvailabilityEntity day});
}
