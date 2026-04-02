import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String spaceName;
  final String timeAgo;
  final int stars;
  final String text;
  final List<String> tags;
  final bool isMine;

  const Review({
    required this.id,
    required this.spaceName,
    required this.timeAgo,
    required this.stars,
    required this.text,
    required this.tags,
    this.isMine = false,
  });

  @override
  List<Object?> get props =>
      [id, spaceName, timeAgo, stars, text, tags, isMine];
}


