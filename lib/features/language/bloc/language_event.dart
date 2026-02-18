import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LanguageStarted extends LanguageEvent {
  const LanguageStarted();
}

class LanguageChanged extends LanguageEvent {
  const LanguageChanged(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
