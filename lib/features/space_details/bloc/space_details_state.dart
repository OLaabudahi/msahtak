import 'package:equatable/equatable.dart';
import '../data/models/space_details_model.dart';

class SpaceDetailsState extends Equatable {
  final bool loading;
  final String? error;

  final SpaceDetails? details;
  final bool isFavorite;
  final bool favoriteUpdating;
  final String? favoriteNoticeKey;

  final int tabIndex;
  final int carouselIndex;

  const SpaceDetailsState({
    required this.loading,
    required this.error,
    required this.details,
    required this.isFavorite,
    required this.favoriteUpdating,
    required this.favoriteNoticeKey,
    required this.tabIndex,
    required this.carouselIndex,
  });

  factory SpaceDetailsState.initial() => const SpaceDetailsState(
    loading: true,
    error: null,
    details: null,
    isFavorite: false,
    favoriteUpdating: false,
    favoriteNoticeKey: null,
    tabIndex: 0,
    carouselIndex: 0,
  );

  SpaceDetailsState copyWith({
    bool? loading,
    String? error,
    SpaceDetails? details,
    bool? isFavorite,
    bool? favoriteUpdating,
    String? favoriteNoticeKey,
    bool clearFavoriteNotice = false,
    int? tabIndex,
    int? carouselIndex,
  }) {
    return SpaceDetailsState(
      loading: loading ?? this.loading,
      error: error,
      details: details ?? this.details,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteUpdating: favoriteUpdating ?? this.favoriteUpdating,
      favoriteNoticeKey: clearFavoriteNotice
          ? null
          : (favoriteNoticeKey ?? this.favoriteNoticeKey),
      tabIndex: tabIndex ?? this.tabIndex,
      carouselIndex: carouselIndex ?? this.carouselIndex,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        error,
        details,
        isFavorite,
        favoriteUpdating,
        favoriteNoticeKey,
        tabIndex,
        carouselIndex,
      ];
}
