import 'package:equatable/equatable.dart';

abstract class WeeklyPlanEvent extends Equatable {
  const WeeklyPlanEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل بيانات الخطة الأسبوعية
class WeeklyPlanStarted extends WeeklyPlanEvent {
  const WeeklyPlanStarted();
}

/// تغيير المساحة المختارة
class WeeklyPlanHubChanged extends WeeklyPlanEvent {
  final String hubId;
  const WeeklyPlanHubChanged(this.hubId);
  @override
  List<Object?> get props => [hubId];
}

/// الضغط على زر تفعيل الخطة
class WeeklyPlanActivatePressed extends WeeklyPlanEvent {
  const WeeklyPlanActivatePressed();
}
