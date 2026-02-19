import 'package:bloc/bloc.dart';

import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/usecases/get_payment_summary_usecase.dart';
import '../../../domain/usecases/pay_booking_request_usecase.dart';
import '../../../domain/repos/payment_repo.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepo _repo;
  final GetPaymentSummaryUseCase _getSummaryUseCase;
  final PayBookingRequestUseCase _payUseCase;

  PaymentBloc({
    required PaymentRepo repo,
    required GetPaymentSummaryUseCase getSummaryUseCase,
    required PayBookingRequestUseCase payUseCase,
  }) : _repo = repo,
       _getSummaryUseCase = getSummaryUseCase,
       _payUseCase = payUseCase,
       super(PaymentState.initial()) {
    on<PaymentStarted>(_onStarted);
    on<PaymentMethodSelected>(_onMethodSelected);
    on<PayNowPressed>(_onPayNow);
  }

  Future<void> _onStarted(
    PaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(uiStatus: PaymentUiStatus.loading, clearError: true));
    try {
      final methods = await _repo.getMethods();
      final summary = await _getSummaryUseCase.call(event.requestId);

      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.ready,
          methods: methods,
          summary: summary,
          selectedMethod: methods.isNotEmpty ? methods.first.type : null,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onMethodSelected(
    PaymentMethodSelected event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(selectedMethod: event.method, clearError: true));
  }

  Future<void> _onPayNow(
    PayNowPressed event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.selectedMethod == null) {
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.failure,
          errorMessage: 'Please select a payment method',
        ),
      );
      return;
    }

    emit(state.copyWith(uiStatus: PaymentUiStatus.paying, clearError: true));
    try {
      final receipt = await _payUseCase.call(
        requestId: event.requestId,
        method: state.selectedMethod!,
      );
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.success,
          receipt: receipt,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
