import 'package:equatable/equatable.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class AnalyticsStarted extends AnalyticsEvent {
  const AnalyticsStarted();
}

class AnalyticsExportPressed extends AnalyticsEvent {
  const AnalyticsExportPressed();
}
