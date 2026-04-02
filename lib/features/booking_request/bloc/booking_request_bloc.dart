import 'dart:async';

import 'package:bloc/bloc.dart';

import '../domain/entities/booking_price_quote_entity.dart';
import '../domain/repos/booking_request_repo.dart';
import '../domain/usecases/cancel_booking_request_usecase.dart';
import '../domain/usecases/create_booking_request_usecase.dart';
import '../domain/usecases/get_booking_request_status_usecase.dart';
import '../domain/usecases/refresh_booking_request_status_usecase.dart';
import 'booking_request_event.dart';
import 'booking_request_state.dart';

class BookingRequestBloc
    extends Bloc<BookingRequestEvent, BookingRequestState> {
  final BookingRequestRepo _repo;
  final CreateBookingRequestUseCase _createUseCase;
  final GetBookingRequestStatusUseCase _getStatusUseCase;
  final RefreshBookingRequestStatusUseCase _refreshStatusUseCase;
  final CancelBookingRequestUseCase _cancelUseCase;


  BookingRequestBloc({
    required BookingRequestRepo repo,
    required CreateBookingRequestUseCase createUseCase,
    required GetBookingRequestStatusUseCase getStatusUseCase,
    required RefreshBookingRequestStatusUseCase refreshStatusUseCase,
    required CancelBookingRequestUseCase cancelUseCase,
  }) : _repo = repo,
       _createUseCase = createUseCase,
       _getStatusUseCase = getStatusUseCase,
       _refreshStatusUseCase = refreshStatusUseCase,
       _cancelUseCase = cancelUseCase,
       super(BookingRequestState.initial()) {
    on<BookingRequestStarted>(_onStarted);
    on<PurposeChanged>(_onPurposeChanged);
    on<StartDateChanged>(_onStartDateChanged);
    on<DurationUnitChanged>(_onDurationUnitChanged);
    on<DurationValueChanged>(_onDurationValueChanged);
    on<OfferChanged>(_onOfferChanged);
    on<AddOnToggled>(_onAddOnToggled);
    on<SubmitBookingRequestPressed>(_onSubmit);
    on<StatusRefreshRequested>(_onRefreshStatus);
    on<CancelRequestPressed>(_onCancel);
    on<BookingRequestStatusOpened>(_onStatusOpened);

  }
  Future<void> _onStatusOpened(
      BookingRequestStatusOpened event,
      Emitter<BookingRequestState> emit,
      ) async {
    emit(state.copyWith(uiStatus: BookingRequestUiStatus.loading, clearError: true));
    try {
      final req = await _getStatusUseCase.call(event.requestId);
      emit(state.copyWith(uiStatus: BookingRequestUiStatus.ready, createdRequest: req, clearError: true));
    } catch (e) {
      emit(state.copyWith(uiStatus: BookingRequestUiStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onStarted(
    BookingRequestStarted event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        uiStatus: BookingRequestUiStatus.loading,
        space: event.space,
        startDate: DateTime.now(),
        addOns: event.availableAddOns,
        clearError: true,
      ),
    );

    await _reQuote(
      emit,
      nextState: state.copyWith(
        space: event.space,
        startDate: DateTime.now(),
        addOns: event.availableAddOns,
      ),
    );

    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onPurposeChanged(
    PurposeChanged event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        purposeId: event.purposeId,
        purposeLabel: event.purposeLabel,
        clearError: true,
      ),
    );
  }

  Future<void> _onStartDateChanged(
    StartDateChanged event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        startDate: event.startDate,
        uiStatus: BookingRequestUiStatus.quoting,
        clearError: true,
      ),
    );
    await _reQuote(emit, nextState: state.copyWith(startDate: event.startDate));
    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onDurationUnitChanged(
    DurationUnitChanged event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        durationUnit: event.unit,
        uiStatus: BookingRequestUiStatus.quoting,
        clearError: true,
      ),
    );
    await _reQuote(emit, nextState: state.copyWith(durationUnit: event.unit));
    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onDurationValueChanged(
    DurationValueChanged event,
    Emitter<BookingRequestState> emit,
  ) async {
    final safeValue = event.value.clamp(1, 365);
    emit(
      state.copyWith(
        durationValue: safeValue,
        uiStatus: BookingRequestUiStatus.quoting,
        clearError: true,
      ),
    );
    await _reQuote(emit, nextState: state.copyWith(durationValue: safeValue));
    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onOfferChanged(
    OfferChanged event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        offerId: event.offerId,
        offerLabel: event.offerLabel,
        uiStatus: BookingRequestUiStatus.quoting,
        clearError: true,
      ),
    );
    await _reQuote(
      emit,
      nextState: state.copyWith(
        offerId: event.offerId,
        offerLabel: event.offerLabel,
      ),
    );
    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onAddOnToggled(
    AddOnToggled event,
    Emitter<BookingRequestState> emit,
  ) async {
    final updated = state.addOns
        .map((a) {
          if (a.id != event.addOnId) return a;
          return a.copyWith(isSelected: event.isSelected);
        })
        .toList(growable: false);

    emit(
      state.copyWith(
        addOns: updated,
        uiStatus: BookingRequestUiStatus.quoting,
        clearError: true,
      ),
    );
    await _reQuote(emit, nextState: state.copyWith(addOns: updated));
    emit(
      state.copyWith(uiStatus: BookingRequestUiStatus.ready, clearError: true),
    );
  }

  Future<void> _onSubmit(
    SubmitBookingRequestPressed event,
    Emitter<BookingRequestState> emit,
  ) async {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.failure,
          errorMessage: 'Please complete required fields',
        ),
      );
      return;
    }

    final space = state.space!;
    final startDate = state.startDate!;
    emit(
      state.copyWith(
        uiStatus: BookingRequestUiStatus.submitting,
        clearError: true,
      ),
    );

    try {
      final created = await _createUseCase.call(
        space: space,
        startDate: startDate,
        durationUnit: state.durationUnit,
        durationValue: state.durationValue,
        purposeId: state.purposeId,
        purposeLabel: state.purposeLabel,
        offerId: state.offerId,
        offerLabel: state.offerLabel,
        addOns: state.addOns,
      );

      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.success,
          createdRequest: created,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshStatus(
    StatusRefreshRequested event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        uiStatus: BookingRequestUiStatus.loading,
        clearError: true,
      ),
    );
    try {
      final updated = await _refreshStatusUseCase.call(event.requestId);
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.ready,
          createdRequest: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCancel(
    CancelRequestPressed event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        uiStatus: BookingRequestUiStatus.loading,
        clearError: true,
      ),
    );
    try {
      final updated = await _cancelUseCase.call(event.requestId);
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.ready,
          createdRequest: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uiStatus: BookingRequestUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _reQuote(
    Emitter<BookingRequestState> emit, {
    required BookingRequestState nextState,
  }) async {
    final space = nextState.space;
    final startDate = nextState.startDate;
    if (space == null || startDate == null) return;

    try {
      final BookingPriceQuoteEntity quote = await _repo.quote(
        space: space,
        startDate: startDate,
        durationUnit: nextState.durationUnit,
        durationValue: nextState.durationValue,
        offerId: nextState.offerId,
        addOns: nextState.addOns,
      );
      emit(nextState.copyWith(quote: quote, clearError: true));
    } catch (e) {
      emit(
        nextState.copyWith(
          uiStatus: BookingRequestUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}


