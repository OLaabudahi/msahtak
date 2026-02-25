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

  /// تحميل جميع العروض من الـ use case
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

  /// فلترة العروض بناءً على نص البحث
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

  /// معالجة الضغط على Deal – يمكن إضافة navigation هنا
  void _onDealPressed(
      OfferDealPressed event, Emitter<OffersState> emit) {
    // TODO: navigate to offer details or booking page
  }
}
