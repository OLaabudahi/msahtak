import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final String id;
  final String name;
  final String location;
  final int originalPrice;
  final int discountedPrice;
  final int discountPercent;
  final double rating;

  const Offer({
    required this.id,
    required this.name,
    required this.location,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        originalPrice,
        discountedPrice,
        discountPercent,
        rating,
      ];
}
