import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeBottomTabChanged extends HomeEvent {
  final int index;
  const HomeBottomTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeCategorySelected extends HomeEvent {
  final int index;
  const HomeCategorySelected(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeNotificationPressed extends HomeEvent {
  const HomeNotificationPressed();
}

class HomeSearchChanged extends HomeEvent {
  final String query;
  const HomeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class HomeFeaturedPageChanged extends HomeEvent {
  final int index;
  const HomeFeaturedPageChanged(this.index);

  @override
  List<Object?> get props => [index];
}