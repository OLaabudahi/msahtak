import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/search_offers_usecase.dart';
import 'offers_event.dart';
import 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final GetOffersUseCase getOffersUseCase;
  final SearchOffersUseCase searchOffersUseCase;

  OffersBloc({
    required this.getOffersUseCase,
    required this.searchOffersUseCase,
  }) : super(const OffersState()) {
    on<OffersStarted>(_onStarted);
    on<OffersSearchChanged>(_onSearchChanged);
    on<OfferDealPressed>(_onDealPressed);
  }

  /// طھط­ظ…ظٹظ„ ط¬ظ…ظٹط¹ ط§ظ„ط¹ط±ظˆط¶ ظ…ظ† ط§ظ„ظ€ use case
  Future<void> _onStarted(
      OffersStarted event, Emitter<OffersState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final offers = await getOffersUseCase();
      emit(state.copyWith(
          allOffers: offers, filteredOffers: offers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// ظپظ„طھط±ط© ط§ظ„ط¹ط±ظˆط¶ ط¨ظ†ط§ط،ظ‹ ط¹ظ„ظ‰ ظ†طµ ط§ظ„ط¨ط­ط«
  Future<void> _onSearchChanged(
      OffersSearchChanged event, Emitter<OffersState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    try {
      final filtered = await searchOffersUseCase(event.query);
      emit(state.copyWith(filteredOffers: filtered));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// ظ…ط¹ط§ظ„ط¬ط© ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ Deal â€“ ظٹظ…ظƒظ† ط¥ط¶ط§ظپط© navigation ظ‡ظ†ط§
  void _onDealPressed(
      OfferDealPressed event, Emitter<OffersState> emit) {
    // TODO: navigate to offer details or booking page
  }
}


