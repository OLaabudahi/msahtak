import 'package:equatable/equatable.dart';
import '../domain/entities/home_featured_space_entity.dart';
import '../domain/entities/insight_item.dart';

class HomeState extends Equatable {
  final int bottomTabIndex;

  final bool isLoading;
  final String? error;

  final int selectedCategoryIndex;

  final List<HomeFeaturedSpaceEntity> featuredSpaces;
  final int featuredIndex;

  final List<InsightItem> insights;

  final int unreadNotifications;

  const HomeState({
    required this.bottomTabIndex,
    required this.isLoading,
    required this.error,
    required this.selectedCategoryIndex,
    required this.featuredSpaces,
    required this.featuredIndex,
    required this.insights,
    required this.unreadNotifications,
  });

  factory HomeState.initial() => const HomeState(
    bottomTabIndex: 0,
    isLoading: true,
    error: null,
    selectedCategoryIndex: 0,
    featuredSpaces: [],
    featuredIndex: 0,
    insights: [],
    unreadNotifications: 1,
  );

  HomeState copyWith({
    int? bottomTabIndex,
    bool? isLoading,
    String? error,
    int? selectedCategoryIndex,
    List<HomeFeaturedSpaceEntity>? featuredSpaces,
    int? featuredIndex,
    List<InsightItem>? insights,
    int? unreadNotifications,
  }) {
    return HomeState(
      bottomTabIndex: bottomTabIndex ?? this.bottomTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      featuredSpaces: featuredSpaces ?? this.featuredSpaces,
      featuredIndex: featuredIndex ?? this.featuredIndex,
      insights: insights ?? this.insights,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
    );
  }

  @override
  List<Object?> get props => [
    bottomTabIndex,
    isLoading,
    error,
    selectedCategoryIndex,
    featuredSpaces,
    featuredIndex,
    insights,
    unreadNotifications,
  ];
}

