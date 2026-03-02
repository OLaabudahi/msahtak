import 'package:equatable/equatable.dart';

enum AdminSettingsStatus { idle, loggingOut, loggedOut, failure }

class AdminSettingsState extends Equatable {
  final AdminSettingsStatus status;
  final String? error;

  const AdminSettingsState({required this.status, required this.error});

  factory AdminSettingsState.initial() => const AdminSettingsState(status: AdminSettingsStatus.idle, error: null);

  AdminSettingsState copyWith({AdminSettingsStatus? status, String? error}) =>
      AdminSettingsState(status: status ?? this.status, error: error);

  @override
  List<Object?> get props => [status, error];
}
