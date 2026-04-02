import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../domain/entities/payment_method_entity.dart';


sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentStarted extends PaymentEvent {
  final String bookingId;

  const PaymentStarted(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class PaymentMethodSelected extends PaymentEvent {
  final PaymentMethodType method;

  const PaymentMethodSelected(this.method);

  @override
  List<Object?> get props => [method];
}

/// ط±ظپط¹ ط¥ط´ط¹ط§ط± ط§ظ„ط¯ظپط¹ ظ…ظ† ظ‚ظگط¨ظژظ„ ط§ظ„ظ…ط³طھط®ط¯ظ…
class PaymentReceiptPicked extends PaymentEvent {
  final Uint8List bytes;
  final String fileName;

  const PaymentReceiptPicked({required this.bytes, required this.fileName});

  @override
  List<Object?> get props => [fileName];
}

/// طھط؛ظٹظٹط± ط­ظ‚ظ„ ظپظٹ ظ†ظ…ظˆط°ط¬ ط¨ط·ط§ظ‚ط© ط§ظ„ط¯ظپط¹
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
  final String bookingId;

  const PayNowPressed(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}


