import 'package:equatable/equatable.dart';

/// ✅ موديل تفاصيل الحجز (هلا Dummy، لاحقاً من API)
class BookingDetails extends Equatable {
  final String bookingId;

  // معلومات المساحة المرتبطة بالحجز
  final String spaceName;
  final double rating;
  final String locationText;
  final List<String> tags;

  /// هلا asset داخل التطبيق، لاحقاً url من API
  final String? imageAsset;
  final String? imageUrl;

  // تفاصيل الحجز
  final String dateText; // مثال: "Mon, 12 Aug"
  final String timeText; // مثال: "09:00 - 12:00"
  final int guestsCount;

  // أسعار
  final double totalPrice;
  final String currency; // مثال: "USD"

  // ملاحظات
  final String notes;

  const BookingDetails({
    required this.bookingId,
    required this.spaceName,
    required this.rating,
    required this.locationText,
    required this.tags,
    this.imageAsset,
    this.imageUrl,
    required this.dateText,
    required this.timeText,
    required this.guestsCount,
    required this.totalPrice,
    required this.currency,
    required this.notes,
  });

  /// ✅ (API جاهز - كومنت) تحويل JSON إلى موديل
  // factory BookingDetails.fromJson(Map<String, dynamic> json) {
  //   return BookingDetails(
  //     bookingId: json['bookingId'].toString(),
  //     spaceName: json['spaceName'] ?? '',
  //     rating: (json['rating'] ?? 0).toDouble(),
  //     locationText: json['locationText'] ?? '',
  //     tags: List<String>.from(json['tags'] ?? const []),
  //     imageUrl: json['imageUrl'],
  //     dateText: json['dateText'] ?? '',
  //     timeText: json['timeText'] ?? '',
  //     guestsCount: (json['guestsCount'] ?? 1) as int,
  //     totalPrice: (json['totalPrice'] ?? 0).toDouble(),
  //     currency: json['currency'] ?? 'USD',
  //     notes: json['notes'] ?? '',
  //   );
  // }

  @override
  List<Object?> get props => [
    bookingId,
    spaceName,
    rating,
    locationText,
    tags,
    imageAsset,
    imageUrl,
    dateText,
    timeText,
    guestsCount,
    totalPrice,
    currency,
    notes,
  ];
}
