import 'package:equatable/equatable.dart';
import '../domain/entities/payment_entity.dart';
import '../domain/entities/payment_details_entity.dart';
import '../domain/entities/payment_status.dart';

enum PaymentsStatusView { initial, loading, ready, failure, acting }

class PaymentsState extends Equatable {
  final PaymentsStatusView status;
  final String periodId;
  final PaymentStatus filter;
  final List<PaymentEntity> payments;
  final PaymentDetailsEntity? details;
  final String? error;

  const PaymentsState({
    required this.status,
    required this.periodId,
    required this.filter,
    required this.payments,
    required this.details,
    required this.error,
  });

  factory PaymentsState.initial() => const PaymentsState(
        status: PaymentsStatusView.initial,
        periodId: 'last30',
        filter: PaymentStatus.paid,
        payments: [],
        details: null,
        error: null,
      );

  PaymentsState copyWith({
    PaymentsStatusView? status,
    String? periodId,
    PaymentStatus? filter,
    List<PaymentEntity>? payments,
    PaymentDetailsEntity? details,
    String? error,
  }) =>
      PaymentsState(
        status: status ?? this.status,
        periodId: periodId ?? this.periodId,
        filter: filter ?? this.filter,
        payments: payments ?? this.payments,
        details: details ?? this.details,
        error: error,
      );

  @override
  List<Object?> get props => [status, periodId, filter, payments, details, error];
}
