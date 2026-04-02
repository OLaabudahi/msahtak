import 'package:equatable/equatable.dart';
import '../domain/entities/user_flag.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();
  @override
  List<Object?> get props => [];
}

class UsersStarted extends UsersEvent {
  const UsersStarted();
}

class UsersQueryChanged extends UsersEvent {
  final String query;
  const UsersQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class UsersFilterChanged extends UsersEvent {
  final UserFlag filter;
  const UsersFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}


