import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/offer_entity.dart';
import '../domain/usecases/create_offer_usecase.dart';
import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/toggle_offer_usecase.dart';
import 'offers_event.dart';
import 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final GetOffersUseCase getOffers;
  final ToggleOfferUseCase toggleOffer;
  final CreateOfferUseCase createOffer;

  OffersBloc({
    required this.getOffers,
    required this.toggleOffer,
    required this.createOffer,
  }) : super(OffersState.initial()) {
    on<OffersStarted>(_onStarted);
    on<OffersTogglePressed>(_onToggle);
    on<OffersCreatePressed>(_onCreate);
  }

  Future<void> _onStarted(OffersStarted event, Emitter<OffersState> emit) async {
    emit(state.copyWith(status: OffersStatus.loading, error: null));
    try {
      final list = await getOffers();
      emit(state.copyWith(status: OffersStatus.ready, offers: list));
    } catch (e) {
      emit(state.copyWith(status: OffersStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onToggle(OffersTogglePressed event, Emitter<OffersState> emit) async {
    await toggleOffer(offerId: event.offerId, enabled: event.enabled);
    add(const OffersStarted());
  }

  Future<void> _onCreate(OffersCreatePressed event, Emitter<OffersState> emit) async {
    final offer = OfferEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      percent: event.percent,
      duration: event.duration,
      terms: event.terms,
      enabled: event.enabled,
    );
    await createOffer(offer: offer);
    add(const OffersStarted());
  }
}
