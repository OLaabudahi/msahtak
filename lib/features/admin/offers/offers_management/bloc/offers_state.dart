import 'package:equatable/equatable.dart';
import '../domain/entities/offer_entity.dart';

enum OffersStatus { initial, loading, ready, failure }

class OffersState extends Equatable {
  final OffersStatus status;
  final List<OfferEntity> offers;
  final String? error;

  const OffersState({
    required this.status,
    required this.offers,
    required this.error,
  });

  factory OffersState.initial() => const OffersState(status: OffersStatus.initial, offers: [], error: null);

  OffersState copyWith({
    OffersStatus? status,
    List<OfferEntity>? offers,
    String? error,
  }) =>
      OffersState(status: status ?? this.status, offers: offers ?? this.offers, error: error);

  @override
  List<Object?> get props => [status, offers, error];
}
