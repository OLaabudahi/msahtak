import 'price_unit.dart';

class PriceEntity {
  final double value;
  final PriceUnit unit;

  const PriceEntity({
    required this.value,
    required this.unit,
  });

  PriceEntity copyWith({
    double? value,
    PriceUnit? unit,
  }) {
    return PriceEntity(
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }
}