import 'package:equatable/equatable.dart';

abstract class AppStartEvent extends Equatable {
  const AppStartEvent();

  @override
  List<Object?> get props => [];
}

class AppStartStarted extends AppStartEvent {
  const AppStartStarted();
}


