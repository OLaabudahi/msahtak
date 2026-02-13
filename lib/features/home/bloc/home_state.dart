part of 'home_bloc.dart';

/// ✅ موديل كروت For You (هلا Dummy، لاحقاً من API)
class FeaturedSpace extends Equatable {
  final String id;
  final String title;
  final double rating;
  final String locationText;
  final List<String> tags;

  /// هلا asset (home.png)، لاحقاً من API imageUrl
  final String? imageUrl;
  final String? imageAsset;

  const FeaturedSpace({
    required this.id,
    required this.title,
    required this.rating,
    required this.locationText,
    required this.tags,
    this.imageUrl,
    this.imageAsset,
  });

  /// ✅ (API جاهز - كومنت) تحويل JSON إلى موديل
  // factory FeaturedSpace.fromJson(Map<String, dynamic> json) {
  //   return FeaturedSpace(
  //     id: json['id'].toString(),
  //     title: json['title'] ?? '',
  //     rating: (json['rating'] ?? 0).toDouble(),
  //     locationText: json['locationText'] ?? '',
  //     tags: List<String>.from(json['tags'] ?? const []),
  //     imageUrl: json['imageUrl'],
  //   );
  // }

  @override
  List<Object?> get props => [id, title, rating, locationText, tags, imageUrl, imageAsset];
}

/// ✅ موديل Insights (هلا Dummy، لاحقاً من API)
class InsightItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  final String? imageUrl;
  final String? imageAsset;

  const InsightItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.imageAsset,
  });

  /// ✅ (API جاهز - كومنت)
  // factory InsightItem.fromJson(Map<String, dynamic> json) {
  //   return InsightItem(
  //     id: json['id'].toString(),
  //     title: json['title'] ?? '',
  //     subtitle: json['subtitle'] ?? '',
  //     imageUrl: json['imageUrl'],
  //   );
  // }

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, imageAsset];
}

class HomeState extends Equatable {
  final int bottomTabIndex;
  final int selectedCategoryIndex;
  final int featuredIndex;
  final String searchText;
  final int unreadNotifications;

  final List<FeaturedSpace> featuredSpaces;
  final List<InsightItem> insights;

  const HomeState({
    required this.bottomTabIndex,
    required this.selectedCategoryIndex,
    required this.featuredIndex,
    required this.searchText,
    required this.unreadNotifications,
    required this.featuredSpaces,
    required this.insights,
  });

  factory HomeState.initial() => const HomeState(
    bottomTabIndex: 0,
    selectedCategoryIndex: 0,
    featuredIndex: 0,
    searchText: '',
    unreadNotifications: 1,
    featuredSpaces: [],
    insights: [],
  );

  String get selectedCategoryLabel {
    const categories = ['Nearly', 'New Suggestion', 'Private Office'];
    final i = selectedCategoryIndex.clamp(0, categories.length - 1);
    return categories[i];
  }

  HomeState copyWith({
    int? bottomTabIndex,
    int? selectedCategoryIndex,
    int? featuredIndex,
    String? searchText,
    int? unreadNotifications,
    List<FeaturedSpace>? featuredSpaces,
    List<InsightItem>? insights,
  }) {
    return HomeState(
      bottomTabIndex: bottomTabIndex ?? this.bottomTabIndex,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      featuredIndex: featuredIndex ?? this.featuredIndex,
      searchText: searchText ?? this.searchText,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      featuredSpaces: featuredSpaces ?? this.featuredSpaces,
      insights: insights ?? this.insights,
    );
  }

  @override
  List<Object?> get props => [
    bottomTabIndex,
    selectedCategoryIndex,
    featuredIndex,
    searchText,
    unreadNotifications,
    featuredSpaces,
    insights,
  ];
}
