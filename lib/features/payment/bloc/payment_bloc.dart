import 'package:bloc/bloc.dart';

import '../domain/usecases/get_payment_details_usecase.dart';
import '../domain/usecases/submit_payment_usecase.dart';
import '../domain/usecases/upload_payment_receipt_usecase.dart';
import '../domain/usecases/verify_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPaymentDetailsUseCase _getPaymentDetailsUseCase;
  final SubmitPaymentUseCase _submitPaymentUseCase;
  final VerifyPaymentUseCase _verifyPaymentUseCase;
  final UploadPaymentReceiptUseCase _uploadPaymentReceiptUseCase;

  PaymentBloc({
    required GetPaymentDetailsUseCase getPaymentDetailsUseCase,
    required SubmitPaymentUseCase submitPaymentUseCase,
    required VerifyPaymentUseCase verifyPaymentUseCase,
    required UploadPaymentReceiptUseCase uploadPaymentReceiptUseCase,
  })  : _getPaymentDetailsUseCase = getPaymentDetailsUseCase,
        _submitPaymentUseCase = submitPaymentUseCase,
        _verifyPaymentUseCase = verifyPaymentUseCase,
        _uploadPaymentReceiptUseCase = uploadPaymentReceiptUseCase,
        super(PaymentState.initial()) {
    on<PaymentStarted>(_onStarted);
    on<PaymentMethodSelected>(_onMethodSelected);
    on<PaymentReceiptPicked>(_onReceiptPicked);
    on<PaymentCardFieldChanged>(_onCardFieldChanged);
    on<PaymentTransferDetailsChanged>(_onTransferDetailsChanged);
    on<PayNowPressed>(_onPayNow);
  }

  Future<void> _onStarted(
    PaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(uiStatus: PaymentUiStatus.loading, clearError: true));
    try {
      final details = await _getPaymentDetailsUseCase.call(event.bookingId);

      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.ready,
          methods: details.methods,
          summary: details.summary,
          selectedMethod: details.methods.isNotEmpty ? details.methods.first.type : null,
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
    emit(
      state.copyWith(
        receiptBytes: event.bytes,
        receiptFileName: event.fileName,
        clearError: true,
      ),
    );
  }

  void _onCardFieldChanged(
    PaymentCardFieldChanged event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        cardNumber: event.cardNumber,
        cardExpiry: event.cardExpiry,
        cardCvv: event.cardCvv,
        cardHolder: event.cardHolder,
        clearError: true,
      ),
    );
  }

  void _onTransferDetailsChanged(
    PaymentTransferDetailsChanged event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        transferAccountHolder: event.accountHolder,
        transferTime: event.transferTime,
        transferReference: event.referenceNumber,
        clearError: true,
      ),
    );
  }

  Future<void> _onPayNow(
    PayNowPressed event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.selectedMethod == null) {
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.failure,
          errorMessage: 'paymentSelectMethodRequired',
        ),
      );
      return;
    }

    final isCard = state.isCardPayment;
    if (!isCard &&
        state.receiptBytes == null &&
        (state.transferAccountHolder.trim().isEmpty ||
            state.transferTime.trim().isEmpty ||
            state.transferReference.trim().isEmpty)) {
      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.failure,
          errorMessage: 'paymentReceiptRequired',
        ),
      );
      return;
    }

    emit(state.copyWith(uiStatus: PaymentUiStatus.paying, clearError: true));
    try {
      String? receiptUrl = state.receiptUploadedUrl;
      if (!isCard && state.receiptBytes != null && state.receiptFileName != null) {
        receiptUrl = await _uploadPaymentReceiptUseCase.call(
          bookingId: event.bookingId,
          bytes: state.receiptBytes!,
          fileName: state.receiptFileName!,
        );
      }

      final selectedEntity = state.selectedMethodEntity;
      final receipt = await _submitPaymentUseCase.call(
        bookingId: event.bookingId,
        method: state.selectedMethod!,
        methodName: selectedEntity?.title ?? state.selectedMethod!,
        receiptUrl: receiptUrl,
        cardNumber: isCard ? state.cardNumber : null,
        cardExpiry: isCard ? state.cardExpiry : null,
        cardCvv: isCard ? state.cardCvv : null,
        cardHolder: isCard ? state.cardHolder : null,
        transferAccountHolder: isCard ? null : state.transferAccountHolder,
        transferTime: isCard ? null : state.transferTime,
        transferReference: isCard ? null : state.transferReference,
      );

      await _verifyPaymentUseCase.call(event.bookingId);

      emit(
        state.copyWith(
          uiStatus: PaymentUiStatus.success,
          receipt: receipt,
          receiptUploadedUrl: receiptUrl,
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
