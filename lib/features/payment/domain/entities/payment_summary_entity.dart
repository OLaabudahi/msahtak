import 'package:equatable/equatable.dart';

class PaymentLineItemEntity extends Equatable {
  final String label;
  final int amount;

  const PaymentLineItemEntity({required this.label, required this.amount});

  @override
  List<Object?> get props => [label, amount];
}

class PaymentSummaryEntity extends Equatable {
  final List<PaymentLineItemEntity> items;
  final int total;
  final String currency;

  const PaymentSummaryEntity({
    required this.items,
    required this.total,
    required this.currency,
  });

  @override
  List<Object?> get props => [items, total, currency];
}


