import '../../domain/entities/booking_price_quote_entity.dart';

class BookingPriceQuoteModel extends BookingPriceQuoteEntity {
  const BookingPriceQuoteModel({
    required super.spaceSubtotal,
    required super.offerDiscount,
    required super.addOnsTotal,
    required super.total,
    required super.currency,
  });

  factory BookingPriceQuoteModel.fromJson(Map<String, dynamic> json) {
    return BookingPriceQuoteModel(
      spaceSubtotal: (json['spaceSubtotal'] as num).toInt(),
      offerDiscount: (json['offerDiscount'] as num).toInt(),
      addOnsTotal: (json['addOnsTotal'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'spaceSubtotal': spaceSubtotal,
    'offerDiscount': offerDiscount,
    'addOnsTotal': addOnsTotal,
    'total': total,
    'currency': currency,
  };
}
