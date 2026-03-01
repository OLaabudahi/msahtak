import '../entities/day_availability_entity.dart';
import '../repos/calendar_repo.dart';

class GetDayUseCase {
  final CalendarRepo repo;
  const GetDayUseCase(this.repo);

  Future<DayAvailabilityEntity> call({required String dayId}) => repo.getDay(dayId: dayId);
}
