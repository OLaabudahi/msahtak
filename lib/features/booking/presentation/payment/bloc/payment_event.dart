import 'package:equatable/equatable.dart';

import '../../../domain/entities/payment_method_entity.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentStarted extends PaymentEvent {
  final String requestId;

  const PaymentStarted(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class PaymentMethodSelected extends PaymentEvent {
  final PaymentMethodType method;

  const PaymentMethodSelected(this.method);

  @override
  List<Object?> get props => [method];
}

class PayNowPressed extends PaymentEvent {
  final String requestId;

  const PayNowPressed(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
