import 'package:equatable/equatable.dart';

sealed class AdminSettingsEvent extends Equatable {
  const AdminSettingsEvent();
  @override
  List<Object?> get props => [];
}

class AdminSettingsLogoutPressed extends AdminSettingsEvent {
  const AdminSettingsLogoutPressed();
}
