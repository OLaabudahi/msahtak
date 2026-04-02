import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.spaceName,
    required super.timeAgo,
    required super.stars,
    required super.text,
    required super.tags,
    super.isMine,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      spaceName: json['spaceName'] as String,
      timeAgo: json['timeAgo'] as String,
      stars: json['stars'] as int,
      text: json['text'] as String,
      tags: List<String>.from(json['tags'] as List),
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'spaceName': spaceName,
        'timeAgo': timeAgo,
        'stars': stars,
        'text': text,
        'tags': tags,
        'isMine': isMine,
      };
}


