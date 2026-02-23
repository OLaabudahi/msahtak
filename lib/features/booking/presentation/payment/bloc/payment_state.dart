import 'package:equatable/equatable.dart';

import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/entities/payment_receipt_entity.dart';
import '../../../domain/entities/payment_summary_entity.dart';

enum PaymentUiStatus { initial, loading, ready, paying, success, failure }

class PaymentState extends Equatable {
  final PaymentUiStatus uiStatus;
  final String? errorMessage;

  final List<PaymentMethodEntity> methods;
  final PaymentMethodType? selectedMethod;

  final PaymentSummaryEntity? summary;
  final PaymentReceiptEntity? receipt;

  const PaymentState({
    required this.uiStatus,
    required this.errorMessage,
    required this.methods,
    required this.selectedMethod,
    required this.summary,
    required this.receipt,
  });

  factory PaymentState.initial() {
    return const PaymentState(
      uiStatus: PaymentUiStatus.initial,
      errorMessage: null,
      methods: <PaymentMethodEntity>[],
      selectedMethod: null,
      summary: null,
      receipt: null,
    );
  }

  PaymentState copyWith({
    PaymentUiStatus? uiStatus,
    String? errorMessage,
    List<PaymentMethodEntity>? methods,
    PaymentMethodType? selectedMethod,
    PaymentSummaryEntity? summary,
    PaymentReceiptEntity? receipt,
    bool clearError = false,
  }) {
    return PaymentState(
      uiStatus: uiStatus ?? this.uiStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      summary: summary ?? this.summary,
      receipt: receipt ?? this.receipt,
    );
  }

  bool get canPay => selectedMethod != null && summary != null;

  @override
  List<Object?> get props => [
    uiStatus,
    errorMessage,
    methods,
    selectedMethod,
    summary,
    receipt,
  ];
}
