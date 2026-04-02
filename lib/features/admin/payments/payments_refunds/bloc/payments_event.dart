import 'package:equatable/equatable.dart';
import '../domain/entities/payment_status.dart';

sealed class PaymentsEvent extends Equatable {
  const PaymentsEvent();
  @override
  List<Object?> get props => [];
}

class PaymentsStarted extends PaymentsEvent {
  const PaymentsStarted();
}

class PaymentsPeriodChanged extends PaymentsEvent {
  final String periodId;
  const PaymentsPeriodChanged(this.periodId);
  @override
  List<Object?> get props => [periodId];
}

class PaymentsStatusChanged extends PaymentsEvent {
  final PaymentStatus status;
  const PaymentsStatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}

class PaymentsOpenDetails extends PaymentsEvent {
  final String paymentId;
  const PaymentsOpenDetails(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}

class PaymentsIssueRefund extends PaymentsEvent {
  final String paymentId;
  const PaymentsIssueRefund(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}


