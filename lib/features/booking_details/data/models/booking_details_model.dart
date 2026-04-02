import 'package:equatable/equatable.dart';

class BookingDetails extends Equatable {
  final String bookingId;
  final String spaceId;

  final String spaceName;
  final double rating;
  final String locationText;

  final List<String> tags;

  final String dateText;
  final String timeText;

  final String notes;

  final num totalPrice;
  final String currency;

  final String? imageAsset;
  final String? imageUrl;

  const BookingDetails({
    required this.bookingId,
    required this.spaceId,
    required this.spaceName,
    required this.rating,
    required this.locationText,
    required this.tags,
    required this.dateText,
    required this.timeText,
    required this.notes,
    required this.totalPrice,
    required this.currency,
    this.imageAsset,
    this.imageUrl,
  });

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  @override
  List<Object?> get props => [
    bookingId,
    spaceId,
    spaceName,
    rating,
    locationText,
    tags,
    dateText,
    timeText,
    notes,
    totalPrice,
    currency,
    imageAsset,
    imageUrl,
  ];
}
