import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../domain/entities/payment_method_entity.dart';


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

/// رفع إشعار الدفع من قِبَل المستخدم
class PaymentReceiptPicked extends PaymentEvent {
  final Uint8List bytes;
  final String fileName;

  const PaymentReceiptPicked({required this.bytes, required this.fileName});

  @override
  List<Object?> get props => [fileName];
}

/// تغيير حقل في نموذج بطاقة الدفع
class PaymentCardFieldChanged extends PaymentEvent {
  final String? cardNumber;
  final String? cardExpiry;
  final String? cardCvv;
  final String? cardHolder;

  const PaymentCardFieldChanged({
    this.cardNumber,
    this.cardExpiry,
    this.cardCvv,
    this.cardHolder,
  });

  @override
  List<Object?> get props => [cardNumber, cardExpiry, cardCvv, cardHolder];
}

class PayNowPressed extends PaymentEvent {
  final String requestId;

  const PayNowPressed(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
