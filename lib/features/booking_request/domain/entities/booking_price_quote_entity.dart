import 'package:equatable/equatable.dart';

class BookingPriceQuoteEntity extends Equatable {
  final int spaceSubtotal;
  final int offerDiscount; // positive number
  final int addOnsTotal;
  final int total;
  final String currency;

  const BookingPriceQuoteEntity({
    required this.spaceSubtotal,
    required this.offerDiscount,
    required this.addOnsTotal,
    required this.total,
    required this.currency,
  });

  @override
  List<Object?> get props => [
    spaceSubtotal,
    offerDiscount,
    addOnsTotal,
    total,
    currency,
  ];
}


