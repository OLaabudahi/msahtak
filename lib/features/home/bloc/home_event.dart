import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

/// ✅ بداية تحميل داتا الهوم
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// ✅ تغيير التاب من الـ BottomNav
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

class HomeNotificationPressed extends HomeEvent {
  const HomeNotificationPressed();
}
