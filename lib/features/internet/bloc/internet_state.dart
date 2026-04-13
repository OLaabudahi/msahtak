import 'package:equatable/equatable.dart';

sealed class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object?> get props => [];
}

class InternetConnected extends InternetState {
  const InternetConnected();
}

class InternetDisconnected extends InternetState {
  const InternetDisconnected();
}
