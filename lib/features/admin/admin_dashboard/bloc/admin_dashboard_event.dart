import 'package:equatable/equatable.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object?> get props => [];
}

class AdminDashboardStarted extends AdminDashboardEvent {
  const AdminDashboardStarted();
}

class AdminDashboardSpaceSelected extends AdminDashboardEvent {
  final String space;

  const AdminDashboardSpaceSelected(this.space);

  @override
  List<Object?> get props => [space];
}

class AdminDashboardDropdownToggled extends AdminDashboardEvent {
  const AdminDashboardDropdownToggled();
}

class AdminDashboardNavChanged extends AdminDashboardEvent {
  final int index;
  const AdminDashboardNavChanged(this.index);

  @override
  List<Object?> get props => [index];
}


