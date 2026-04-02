import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class Booking extends Equatable {
  final String bookingId;
  final String spaceId;

  final String spaceName;
  final String dateText; 
  final String timeText; 
  final String status; 
  final double totalPrice;
  final String currency;

  
  final String? imageAsset;
  final String? imageUrl;

  const Booking({
    required this.bookingId,
    required this.spaceId,
    required this.spaceName,
    required this.dateText,
    required this.timeText,
    required this.status,
    required this.totalPrice,
    required this.currency,
    this.imageAsset,
    this.imageUrl,
  });

  
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageAsset ?? 'assets/images/home.png');
  }

  
  
  
  
  
  
  
  
  
  
  
  
  

  @override
  List<Object?> get props => [
    bookingId,
    spaceId,
    spaceName,
    dateText,
    timeText,
    status,
    totalPrice,
    currency,
    imageAsset,
    imageUrl,
  ];
}
