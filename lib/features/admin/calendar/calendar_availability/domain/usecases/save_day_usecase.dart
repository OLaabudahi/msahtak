import '../entities/day_availability_entity.dart';
import '../repos/calendar_repo.dart';

class SaveDayUseCase {
  final CalendarRepo repo;
  const SaveDayUseCase(this.repo);

  Future<void> call({required DayAvailabilityEntity day}) => repo.saveDay(day: day);
}


