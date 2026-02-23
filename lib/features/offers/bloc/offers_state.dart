import 'package:equatable/equatable.dart';
import '../domain/entities/offer.dart';

class OffersState extends Equatable {
  final List<Offer> allOffers;
  final List<Offer> filteredOffers;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const OffersState({
    this.allOffers = const [],
    this.filteredOffers = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  OffersState copyWith({
    List<Offer>? allOffers,
    List<Offer>? filteredOffers,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return OffersState(
      allOffers: allOffers ?? this.allOffers,
      filteredOffers: filteredOffers ?? this.filteredOffers,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [allOffers, filteredOffers, searchQuery, isLoading, error];
}
