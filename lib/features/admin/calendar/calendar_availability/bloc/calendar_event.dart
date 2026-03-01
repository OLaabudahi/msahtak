import 'package:equatable/equatable.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();
  @override
  List<Object?> get props => [];
}

class CalendarStarted extends CalendarEvent {
  final String dayId;
  const CalendarStarted(this.dayId);
  @override
  List<Object?> get props => [dayId];
}

class CalendarClosedToggled extends CalendarEvent {
  final bool closed;
  const CalendarClosedToggled(this.closed);
  @override
  List<Object?> get props => [closed];
}

class CalendarSpecialHoursChanged extends CalendarEvent {
  final String value;
  const CalendarSpecialHoursChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class CalendarSavePressed extends CalendarEvent {
  const CalendarSavePressed();
}
