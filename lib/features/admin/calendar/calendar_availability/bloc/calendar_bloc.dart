import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/day_availability_entity.dart';
import '../domain/usecases/get_day_usecase.dart';
import '../domain/usecases/save_day_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetDayUseCase getDay;
  final SaveDayUseCase saveDay;

  CalendarBloc({required this.getDay, required this.saveDay}) : super(CalendarState.initial()) {
    on<CalendarStarted>(_onStarted);
    on<CalendarClosedToggled>(_onClosed);
    on<CalendarSpecialHoursChanged>(_onHours);
    on<CalendarSavePressed>(_onSave);
  }

  Future<void> _onStarted(CalendarStarted event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(status: CalendarStatus.loading, error: null));
    try {
      final d = await getDay(dayId: event.dayId);
      emit(state.copyWith(status: CalendarStatus.ready, day: d));
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, error: e.toString()));
    }
  }

  void _onClosed(CalendarClosedToggled event, Emitter<CalendarState> emit) {
    final d = state.day;
    if (d == null) return;
    emit(state.copyWith(day: DayAvailabilityEntity(dayId: d.dayId, closed: event.closed, specialHours: d.specialHours)));
  }

  void _onHours(CalendarSpecialHoursChanged event, Emitter<CalendarState> emit) {
    final d = state.day;
    if (d == null) return;
    emit(state.copyWith(day: DayAvailabilityEntity(dayId: d.dayId, closed: d.closed, specialHours: event.value)));
  }

  Future<void> _onSave(CalendarSavePressed event, Emitter<CalendarState> emit) async {
    final d = state.day;
    if (d == null) return;
    emit(state.copyWith(status: CalendarStatus.saving, error: null));
    try {
      await saveDay(day: d);
      emit(state.copyWith(status: CalendarStatus.saved));
      emit(state.copyWith(status: CalendarStatus.ready));
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, error: e.toString()));
    }
  }
}
