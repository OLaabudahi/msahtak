import 'payment_method_entity.dart';
import 'payment_summary_entity.dart';

class PaymentDetailsEntity {
  final List<PaymentMethodEntity> methods;
  final PaymentSummaryEntity summary;

  const PaymentDetailsEntity({
    required this.methods,
    required this.summary,
  });
}
