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
  });

  /// طھط­ظˆظٹظ„ JSON ط¥ظ„ظ‰ Model
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      originalPrice: json['originalPrice'] as int,
      discountedPrice: json['discountedPrice'] as int,
      discountPercent: json['discountPercent'] as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  /// طھط­ظˆظٹظ„ Model ط¥ظ„ظ‰ JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'originalPrice': originalPrice,
        'discountedPrice': discountedPrice,
        'discountPercent': discountPercent,
        'rating': rating,
      };
}


