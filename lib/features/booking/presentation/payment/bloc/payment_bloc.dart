import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    on<PaymentReceiptPicked>(_onReceiptPicked);
    on<PaymentCardFieldChanged>(_onCardFieldChanged);
    on<PayNowPressed>(_onPayNow);
  }

  Future<void> _onStarted(
    PaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(uiStatus: PaymentUiStatus.loading, clearError: true));
    try {
      final methods = await _repo.getMethods(requestId: event.requestId);
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

  void _onReceiptPicked(
    PaymentReceiptPicked event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(
      receiptBytes: event.bytes,
      receiptFileName: event.fileName,
      clearError: true,
    ));
  }

  void _onCardFieldChanged(
    PaymentCardFieldChanged event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(
      cardNumber: event.cardNumber,
      cardExpiry: event.cardExpiry,
      cardCvv: event.cardCvv,
      cardHolder: event.cardHolder,
      clearError: true,
    ));
  }

  Future<void> _onPayNow(
    PayNowPressed event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.selectedMethod == null) {
      emit(state.copyWith(uiStatus: PaymentUiStatus.failure, errorMessage: 'Please select a payment method'));
      return;
    }

    final isCard = state.isCardPayment;
    if (!isCard && state.receiptBytes == null) {
      emit(state.copyWith(uiStatus: PaymentUiStatus.failure, errorMessage: 'paymentReceiptRequired'));
      return;
    }

    emit(state.copyWith(uiStatus: PaymentUiStatus.paying, clearError: true));
    try {
      String? receiptUrl;

      if (!isCard) {
        // رفع إشعار الدفع للطرق غير البطاقة
        try {
          final ext = (state.receiptFileName ?? 'receipt').split('.').last.toLowerCase();
          if (kIsWeb) {
            receiptUrl = 'data:image/$ext;base64,${base64Encode(state.receiptBytes!)}';
          } else {
            final ref = FirebaseStorage.instance
                .ref()
                .child('receipts/${event.requestId}_${DateTime.now().millisecondsSinceEpoch}.$ext');
            await ref.putData(state.receiptBytes!);
            receiptUrl = await ref.getDownloadURL();
          }
        } catch (_) {}
      }

      final selectedEntity = state.selectedMethodEntity;
      final receipt = await _payUseCase.call(
        requestId: event.requestId,
        method: state.selectedMethod!,
        methodName: selectedEntity?.title ?? state.selectedMethod!,
        receiptUrl: receiptUrl,
        cardNumber: isCard ? state.cardNumber : null,
        cardExpiry: isCard ? state.cardExpiry : null,
        cardCvv: isCard ? state.cardCvv : null,
        cardHolder: isCard ? state.cardHolder : null,
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
