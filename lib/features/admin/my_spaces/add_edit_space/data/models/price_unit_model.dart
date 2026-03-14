import '../../domain/entities/price_unit.dart';

class PriceUnitModel {
  static String toJson(PriceUnit u) => switch (u) { PriceUnit.week => 'week', PriceUnit.month => 'month', _ => 'day' };

  static PriceUnit fromJson(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'week':
        return PriceUnit.week;
      case 'month':
        return PriceUnit.month;
      default:
        return PriceUnit.day;
    }
  }
}
