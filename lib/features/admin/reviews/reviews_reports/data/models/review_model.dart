import '../../domain/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String userName;
  final String spaceName;
  final String dateLabel;
  final String stars;
  final String text;
  final String? adminReply;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.spaceName,
    required this.dateLabel,
    required this.stars,
    required this.text,
    required this.adminReply,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: (json['id'] ?? '').toString(),
    userName: (json['userName'] ?? '').toString(),
    spaceName: (json['spaceName'] ?? '').toString(),
    dateLabel: (json['dateLabel'] ?? '').toString(),
    stars: (json['stars'] ?? '').toString(),
    text: (json['text'] ?? '').toString(),
    adminReply: json['adminReply']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'spaceName': spaceName,
    'dateLabel': dateLabel,
    'stars': stars,
    'text': text,
    'adminReply': adminReply,
  };

  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    userName: userName,
    spaceName: spaceName,
    dateLabel: dateLabel,
    stars: stars,
    text: text,
    adminReply: adminReply,
  );
}