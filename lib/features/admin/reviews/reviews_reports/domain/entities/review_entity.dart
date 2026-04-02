import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userName;
  final String spaceName; // NEW
  final String dateLabel; // NEW (e.g. Feb 25, 2026)
  final String stars;
  final String text;
  final String? adminReply; // NEW

  const ReviewEntity({
    required this.id,
    required this.userName,
    required this.spaceName,
    required this.dateLabel,
    required this.stars,
    required this.text,
    required this.adminReply,
  });

  @override
  List<Object?> get props => [id, userName, spaceName, dateLabel, stars, text, adminReply];
}