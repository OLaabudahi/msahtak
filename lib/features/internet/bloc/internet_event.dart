import 'package:equatable/equatable.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object?> get props => [];
}

class CheckConnection extends InternetEvent {
  const CheckConnection();
}

class ConnectionRestored extends InternetEvent {
  const ConnectionRestored();
}

class ConnectionLost extends InternetEvent {
  const ConnectionLost();
}
