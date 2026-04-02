import '../../domain/entities/payment_summary_entity.dart';

class PaymentSummaryModel extends PaymentSummaryEntity {
  const PaymentSummaryModel({
    required super.items,
    required super.total,
    required super.currency,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => PaymentLineItemEntity(
              label: (e as Map<String, dynamic>)['label'] as String,
              amount: (e['amount'] as num).toInt(),
            ),
          )
          .toList(growable: false),
      total: (json['total'] as num).toInt(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items
        .map((e) => {'label': e.label, 'amount': e.amount})
        .toList(growable: false),
    'total': total,
    'currency': currency,
  };
}
