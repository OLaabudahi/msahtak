import 'package:equatable/equatable.dart';

enum PaymentMethodType { card, palPay, jawwalPay, bankOfPalestine }

class PaymentMethodEntity extends Equatable {
  final PaymentMethodType type;
  final String title;

  const PaymentMethodEntity({required this.type, required this.title});

  @override
  List<Object?> get props => [type, title];
}
