part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
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

class HomeFeaturedPageChanged extends HomeEvent {
  final int index;
  const HomeFeaturedPageChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class HomeSearchChanged extends HomeEvent {
  final String text;
  const HomeSearchChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class HomeNotificationPressed extends HomeEvent {
  const HomeNotificationPressed();
}
