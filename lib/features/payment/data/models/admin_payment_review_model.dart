class AdminPaymentReviewModel {
  final String bookingId;
  final String userId;
  final String spaceId;
  final String spaceName;
  final int amount;
  final String currency;
  final String paymentMethod;
  final String? receiptUrl;
  final DateTime paidAt;
  final String status;
  final DateTime createdAt;

  const AdminPaymentReviewModel({
    required this.bookingId,
    required this.userId,
    required this.spaceId,
    required this.spaceName,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    this.receiptUrl,
    required this.paidAt,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'spaceId': spaceId,
      'spaceName': spaceName,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'paymentReceiptUrl': receiptUrl,
      'paidAt': paidAt.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
