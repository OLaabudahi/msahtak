import 'package:equatable/equatable.dart';

class FeaturedSpace extends Equatable {
  final String id;
  final String title;
  final double rating;
  final String locationText;
  final List<String> tags;
  final String? imageAsset;
  final String? imageUrl; // API-ready

  const FeaturedSpace({
    required this.id,
    required this.title,
    required this.rating,
    required this.locationText,
    required this.tags,
    this.imageAsset,
    this.imageUrl,
  });

  /// ✅ API READY (كومنت)
  // factory FeaturedSpace.fromJson(Map<String, dynamic> json) => FeaturedSpace(
  //   id: json['id'].toString(),
  //   title: json['title'] ?? '',
  //   rating: (json['rating'] ?? 0).toDouble(),
  //   locationText: json['locationText'] ?? '',
  //   tags: List<String>.from(json['tags'] ?? []),
  //   imageUrl: json['imageUrl'],
  // );

  @override
  List<Object?> get props => [id, title, rating, locationText, tags, imageAsset, imageUrl];
}

class InsightItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? imageUrl; // API-ready

  const InsightItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.imageUrl,
  });

  /// ✅ API READY (كومنت)
  // factory InsightItem.fromJson(Map<String, dynamic> json) => InsightItem(
  //   id: json['id'].toString(),
  //   title: json['title'] ?? '',
  //   subtitle: json['subtitle'] ?? '',
  //   imageUrl: json['imageUrl'],
  // );

  @override
  List<Object?> get props => [id, title, subtitle, imageAsset, imageUrl];
}

class HomeState extends Equatable {
  final int bottomTabIndex;

  final int selectedCategoryIndex;
  final String searchQuery;

  final int featuredIndex;
  final List<FeaturedSpace> featuredSpaces;

  final List<InsightItem> insights;

  final int unreadNotifications;

  const HomeState({
    required this.bottomTabIndex,
    required this.selectedCategoryIndex,
    required this.searchQuery,
    required this.featuredIndex,
    required this.featuredSpaces,
    required this.insights,
    required this.unreadNotifications,
  });

  factory HomeState.initial() => const HomeState(
    bottomTabIndex: 0,
    selectedCategoryIndex: 0,
    searchQuery: '',
    featuredIndex: 0,
    featuredSpaces: [],
    insights: [],
    unreadNotifications: 2,
  );

  HomeState copyWith({
    int? bottomTabIndex,
    int? selectedCategoryIndex,
    String? searchQuery,
    int? featuredIndex,
    List<FeaturedSpace>? featuredSpaces,
    List<InsightItem>? insights,
    int? unreadNotifications,
  }) {
    return HomeState(
      bottomTabIndex: bottomTabIndex ?? this.bottomTabIndex,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      featuredIndex: featuredIndex ?? this.featuredIndex,
      featuredSpaces: featuredSpaces ?? this.featuredSpaces,
      insights: insights ?? this.insights,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
    );
  }

  @override
  List<Object?> get props => [
    bottomTabIndex,
    selectedCategoryIndex,
    searchQuery,
    featuredIndex,
    featuredSpaces,
    insights,
    unreadNotifications,
  ];
}
