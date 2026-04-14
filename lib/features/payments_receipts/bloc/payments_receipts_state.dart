import 'package:equatable/equatable.dart';

import '../domain/entities/user_receipt_entity.dart';

class PaymentsReceiptsState extends Equatable {
  final bool loading;
  final String? error;
  final List<UserReceiptEntity> receipts;
  final Map<int, double> monthlyPayments;
  final bool showAllReceipts;

  const PaymentsReceiptsState({
    required this.loading,
    required this.error,
    required this.receipts,
    required this.monthlyPayments,
    required this.showAllReceipts,
  });

  factory PaymentsReceiptsState.initial() => const PaymentsReceiptsState(
        loading: true,
        error: null,
        receipts: [],
        monthlyPayments: {},
        showAllReceipts: false,
      );

  PaymentsReceiptsState copyWith({
    bool? loading,
    String? error,
    List<UserReceiptEntity>? receipts,
    Map<int, double>? monthlyPayments,
    bool? showAllReceipts,
  }) {
    return PaymentsReceiptsState(
      loading: loading ?? this.loading,
      error: error,
      receipts: receipts ?? this.receipts,
      monthlyPayments: monthlyPayments ?? this.monthlyPayments,
      showAllReceipts: showAllReceipts ?? this.showAllReceipts,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        error,
        receipts,
        monthlyPayments,
        showAllReceipts,
      ];
}
