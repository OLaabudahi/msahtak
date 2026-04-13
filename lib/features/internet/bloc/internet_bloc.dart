import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repos/internet_repo.dart';
import '../domain/usecases/check_internet_connection_usecase.dart';
import 'internet_event.dart';
import 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final CheckInternetConnectionUseCase checkInternetConnectionUseCase;
  late final StreamSubscription<bool> _connectionSub;

  InternetBloc({required InternetRepo repo})
      : checkInternetConnectionUseCase = CheckInternetConnectionUseCase(repo),
        super(const InternetConnected()) {
    on<CheckConnection>(_onCheckConnection);
    on<ConnectionRestored>(_onConnectionRestored);
    on<ConnectionLost>(_onConnectionLost);

    _connectionSub = repo.watchConnection().listen((isConnected) {
      add(isConnected ? const ConnectionRestored() : const ConnectionLost());
    });
  }

  Future<void> _onCheckConnection(
    CheckConnection event,
    Emitter<InternetState> emit,
  ) async {
    final isConnected = await checkInternetConnectionUseCase();
    emit(isConnected ? const InternetConnected() : const InternetDisconnected());
  }

  void _onConnectionRestored(
    ConnectionRestored event,
    Emitter<InternetState> emit,
  ) {
    emit(const InternetConnected());
  }

  void _onConnectionLost(
    ConnectionLost event,
    Emitter<InternetState> emit,
  ) {
    emit(const InternetDisconnected());
  }

  @override
  Future<void> close() async {
    await _connectionSub.cancel();
    return super.close();
  }
}
