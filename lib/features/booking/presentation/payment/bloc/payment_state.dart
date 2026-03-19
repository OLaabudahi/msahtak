import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/entities/payment_receipt_entity.dart';
import '../../../domain/entities/payment_summary_entity.dart';

enum PaymentUiStatus { initial, loading, ready, uploadingReceipt, paying, success, failure }

class PaymentState extends Equatable {
  final PaymentUiStatus uiStatus;
  final String? errorMessage;

  final List<PaymentMethodEntity> methods;
  final PaymentMethodType? selectedMethod;

  final PaymentSummaryEntity? summary;
  final PaymentReceiptEntity? receipt;

  // إشعار الدفع الذي رفعه المستخدم
  final Uint8List? receiptBytes;
  final String? receiptFileName;
  final String? receiptUploadedUrl;

  // حقول بطاقة الدفع
  final String cardNumber;
  final String cardExpiry;
  final String cardCvv;
  final String cardHolder;

  const PaymentState({
    required this.uiStatus,
    required this.errorMessage,
    required this.methods,
    required this.selectedMethod,
    required this.summary,
    required this.receipt,
    this.receiptBytes,
    this.receiptFileName,
    this.receiptUploadedUrl,
    this.cardNumber = '',
    this.cardExpiry = '',
    this.cardCvv = '',
    this.cardHolder = '',
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
    Uint8List? receiptBytes,
    String? receiptFileName,
    String? receiptUploadedUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    bool clearError = false,
    bool clearReceipt = false,
  }) {
    return PaymentState(
      uiStatus: uiStatus ?? this.uiStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      methods: methods ?? this.methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      summary: summary ?? this.summary,
      receipt: receipt ?? this.receipt,
      receiptBytes: clearReceipt ? null : (receiptBytes ?? this.receiptBytes),
      receiptFileName: clearReceipt ? null : (receiptFileName ?? this.receiptFileName),
      receiptUploadedUrl: clearReceipt ? null : (receiptUploadedUrl ?? this.receiptUploadedUrl),
      cardNumber: cardNumber ?? this.cardNumber,
      cardExpiry: cardExpiry ?? this.cardExpiry,
      cardCvv: cardCvv ?? this.cardCvv,
      cardHolder: cardHolder ?? this.cardHolder,
    );
  }

  PaymentMethodEntity? get selectedMethodEntity =>
      selectedMethod == null ? null : methods.where((m) => m.type == selectedMethod).firstOrNull;

  /// هل طريقة الدفع المختارة بطاقة ائتمان/خصم؟
  bool get isCardPayment {
    if (selectedMethod == null) return false;
    final m = selectedMethod!.toLowerCase();
    return m.contains('credit') || m.contains('debit') || m.contains('card') || m.contains('visa') || m.contains('master');
  }

  /// يمكن الدفع:
  /// - بطاقة: يجب أن تكون جميع حقول البطاقة ممتلئة
  /// - طريقة أخرى: يجب رفع إشعار الدفع
  bool get canPay {
    if (selectedMethod == null || summary == null) return false;
    if (isCardPayment) {
      return cardNumber.trim().isNotEmpty &&
          cardExpiry.trim().isNotEmpty &&
          cardCvv.trim().isNotEmpty &&
          cardHolder.trim().isNotEmpty;
    }
    return receiptBytes != null;
  }

  @override
  List<Object?> get props => [
    uiStatus,
    errorMessage,
    methods,
    selectedMethod,
    summary,
    receipt,
    receiptFileName,
    receiptUploadedUrl,
    cardNumber,
    cardExpiry,
    cardCvv,
    cardHolder,
  ];
}
