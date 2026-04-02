import 'package:equatable/equatable.dart';
import '../data/models/space_details_model.dart';

class SpaceDetailsState extends Equatable {
  final bool loading;
  final String? error;

  final SpaceDetails? details;

  final int tabIndex;
  final int carouselIndex;

  const SpaceDetailsState({
    required this.loading,
    required this.error,
    required this.details,
    required this.tabIndex,
    required this.carouselIndex,
  });

  factory SpaceDetailsState.initial() => const SpaceDetailsState(
    loading: true,
    error: null,
    details: null,
    tabIndex: 0,
    carouselIndex: 0,
  );

  SpaceDetailsState copyWith({
    bool? loading,
    String? error,
    SpaceDetails? details,
    int? tabIndex,
    int? carouselIndex,
  }) {
    return SpaceDetailsState(
      loading: loading ?? this.loading,
      error: error,
      details: details ?? this.details,
      tabIndex: tabIndex ?? this.tabIndex,
      carouselIndex: carouselIndex ?? this.carouselIndex,
    );
  }

  @override
  List<Object?> get props => [loading, error, details, tabIndex, carouselIndex];
}


