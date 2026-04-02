import 'package:equatable/equatable.dart';


typedef PaymentMethodType = String;

class PaymentMethodEntity extends Equatable {
  final PaymentMethodType type;
  final String title;
  final String details; 

  const PaymentMethodEntity({
    required this.type,
    required this.title,
    this.details = '',
  });

  @override
  List<Object?> get props => [type, title, details];
}
