import 'package:equatable/equatable.dart';

/// معرّف طريقة الدفع — String بدلاً من enum لدعم الطرق الديناميكية من Firebase
typedef PaymentMethodType = String;

class PaymentMethodEntity extends Equatable {
  final PaymentMethodType type;
  final String title;
  final String details; // تفاصيل الحساب التي يدخلها الأدمن

  const PaymentMethodEntity({
    required this.type,
    required this.title,
    this.details = '',
  });

  @override
  List<Object?> get props => [type, title, details];
}
