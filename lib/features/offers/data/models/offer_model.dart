import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.name,
    required super.location,
    required super.originalPrice,
    required super.discountedPrice,
    required super.discountPercent,
    required super.rating,
    super.discountLabel,
  });

  /// تحويل JSON إلى Model
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      originalPrice: json['originalPrice'] as int,
      discountedPrice: json['discountedPrice'] as int,
      discountPercent: json['discountPercent'] as int,
      rating: (json['rating'] as num).toDouble(),
      discountLabel: json['discountLabel'] as String?,
    );
  }

  /// تحويل Model إلى JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'originalPrice': originalPrice,
        'discountedPrice': discountedPrice,
        'discountPercent': discountPercent,
        'rating': rating,
        'discountLabel': discountLabel,
      };
}
