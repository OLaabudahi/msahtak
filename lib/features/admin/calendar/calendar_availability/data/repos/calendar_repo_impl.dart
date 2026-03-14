import '../../domain/entities/day_availability_entity.dart';
import '../../domain/repos/calendar_repo.dart';
import '../models/day_availability_model.dart';
import '../sources/calendar_source.dart';

class CalendarRepoImpl implements CalendarRepo {
  final CalendarSource source;
  const CalendarRepoImpl(this.source);

  @override
  Future<DayAvailabilityEntity> getDay({required String dayId}) async {
    final m = await source.fetchDay(dayId: dayId);
    return m.toEntity();
  }

  @override
  Future<void> saveDay({required DayAvailabilityEntity day}) {
    final m = DayAvailabilityModel(dayId: day.dayId, closed: day.closed, specialHours: day.specialHours);
    return source.saveDay(day: m);
  }
}
